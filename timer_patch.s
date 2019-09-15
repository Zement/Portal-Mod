# 0x80fyyzz0 r7, current time in seconds * 60, thus untouched
# 0x80fyyzz4 record time, also untouched
# 0x80429fa0 points_addr, 0x80fyyzz0 / 60, preferably also with tenths
# 0x80d25bf8 regular_timeslot, (0x80fyyzz0 / 60) << 12

#TODO:
# -print xxx0y time instead of xxx, where y is tenths
# -print the time so it is NOT added on with points!

# 800e3ad4 48212c3c; b 0x802f6710; might be better to drive here

#i 802f6710:

#lwz r0.20 (r1) #orig for 3b38
lbz r0.10 (r31) #orig for 3ad4

#save registers
stwu r5, -0x4 (sp)
stwu r6, -0x4 (sp)
stwu r4, -0x4 (sp)
stwu r3, -0x4 (sp)
stwu r7, -0x4 (sp)
stwu r8, -0x4 (sp)

#set r7 = 0x80fyyzz0
lis r5, 0x80d2
addi r5, r5,0x5408 # r5 = 0x80d25408 = world_addr
lwz r6, 0 (r5) # r6 = world
lis r5, 0x80d2
addi r5, r5,0x50a8 # r5 = 0x80d250a8 = stage_addr
lwz r4, 0 (r5) # r4 = stage
li r3, 12 #shift like this a lot
slw r6, r6, r3 #shifta r6 12 steps
li r3, 4 #shifta 4
slw r4, r4, r3 #shifta r4 4
lis r7, 0x80f0
or r7, r7, r6
or r7, r7, r4 # r7 = 0x80fyyzz0

#check if finished playing, 1 at address 803551e4 if yes, 0 if no
lis r5, 0x8035
ori r5, r5,0x51e4 # r5 = 0x803551e4
lwz r6, 0 (r5) # r6 = value in r5
cmpwi r6,1 # r6 == 1?
beq .stage_complete #yepp, jump to stage_complete
#here r6 == 0

#store timer ++ in 0x80fyyzz0
lwz r6, 0 (r7) # r6 = value from 0x80fyyzz0
addi r6, r6,1 # hours ++
stw r6, 0 (r7) #store it back

#make sure the record isn't zero
lwz r3, 4 (r7) # r3 = value in r7 + 4 = record
cmpwi r3,0 #compare r3 to zero
bne .print_record #if not, jump
li r3,0x7512 #else, set record to 0x7512 = 999 * 60/2
addi r3, r3,0x7512 # r3 = 999 * 60
stw r3,4 (r7) #record = 999 * 60

#print record at regular timeslot, 80d25bf8
.print_record:
lwz r3, 4 (r7) # r3 = record
li r5, 60 #div 60
divwu r3, r3, r5 #divide record at 60
li r4, 0xc #shift 12 steps
slw r3, r3, r4 #shift r3 12 steps to the left

lis r5,0x80d2
ori r5, r5,0x5bf8 # r5 = time_addr
stw r3, 0 (r5) #store (record / 60) << 12 in time_addr

#print timer into points_addr
lis r5, 0x8042 # r5 = 0x80420000
addi r5, r5,0x4fd0
addi r5, r5,0x4fd0 # r5 = 0x80429fa0

li r3.10 # r3 = 10
mullw r4, r6, r3 # r4 = timer * 10
li r3, 60 # r3 = 60
divw r4, r4, r3 # r4 = timer * 10/60

li r3,60 #load 60 into r3
divwu r6, r6, r3 #hours = hours / 60

#li r3,10 # r3 = 10
#mullw r5, r6, r3 # r5 = rounded timer value #DENNA FAILAR !! WHYYY ??
mulli r6, r6,10 #test this is? hours * = 10
sub r4, r4, r6 # r4 = remainder
li r3.10 # 10 into r3
mullw r6, r6, r3 #timer * = 10
add r6, r6, r4 #timer = xx0y
stw r6, 0 (r5) #store back, r6 holds timer value, in the form xx0y
lwz r8, 0 (r5) #store the timer value in r8 as well
stw r8, 8 (r7) #store it into 0x80fyyzz8 as well!

b .end #jump past stage_complete

.stage_complete:
#here the stage is complete

lis r5,0x80d2
ori r5, r5,0x5bf8 # r5 = time_addr
li r3,0 # r3 = 0
#stw r3, 0 (r5) #store 0 to regular timeslot so it won't get
#added to the points etc!

#load final time once again!
lis r5, 0x8042
addi r5, r5,0x4fd0
addi r5, r5,0x4fd0 # r5 = 0x80429fa0
lwz r8, 8 (r7) # r8 = 0x80fyyzz8 = xx0y time
stw r8, 0 (r5)

#check if it's a new record!
lwz r4, 0 (r7) # r4 = value in 0x80fyyz0
lwz r5, 4 (r7) # r5 = value in 0x80fyyz4 = record

cmp 0.1, r5, r4
bt lt, .recordend # r4> r5 => no record, go to recordend
stw r4, 4 (r7) #record the record

.recordend:
li r3,0 #store 0 to r3
stw r3, 0 (r7) #reset timer for next run etc

.end:

lwzu r8, 0 (sp)
lwzu r7, 4 (sp)
lwzu r3, 4 (sp)
lwzu r4, 4 (sp)
lwzu r6, 4 (sp)
lwzu r5, 4 (sp)
addi r1, r1,4
#b back




# 0x4BDEd2e0- (x-30 * 2) * 4 where x = number of memory locations besides this!


<memory offset = "0x800e3ad4" value = "48212c3c" />
<Memory Offset = "0x802f6710" value = "881F000A94A1FFFC94C1FFFC9481FFFC9461FFFC94E1FFFC9501FFFC3CA080D238A5540880C500003CA080D238A550A8808500003860000C7CC61830386000047C8418303CE080F07CE733787CE723783CA0803560A551E480C500002C0600014182009080C7000038C6000190C70000806700042C030000408200103860751238637512906700048067000438A0003C7C632B963880000C7C6320303CA080D260A55BF8906500003CA0804238A54FD038A54FD03860000A7C8619D63860003C7C841BD63860003C7CC61B961CC6000A7C8620503860000A7CC619D67CC6221490C500008105000091070008480000403CA080D260A55BF8386000003CA0804238A54FD038A54FD081070008910500008087000080A700047C252000418000089087000438600000906700008501000084E10004846100048481000484C1000484A10004382100044BDED288" />
