//int main(int argc, char *argv[])
//#include<stdio.h>

int main(void)
{
  float *base_addr;// = (float*)0x802f6940;
  base_addr = (float*)0x802f6900;
  float ** goomba_addr = (float**)0x802f6930;
  int * tmpint = (int*)(base_addr+6);
  float * tmp = (float*)(base_addr+5);
  float * tmp2 = (float*)(base_addr+7);
  int * portal_timer = (int*)(base_addr+8);
  int * first_portal = (int*)(base_addr);
  int * second_portal = (int*)(base_addr+1);
  int * curr_portal = (int*)(base_addr+2);
  float * player_addr = (float*)0x8154b804;
  int * player_dir_addr = (int*)0x8154b904;
  float * dist = (float*)(base_addr+10);

  //int * goomba = *goomba_addr;
  
  
  float * tilt_addr = (float*)0x807612c8;
  *(base_addr+5) = 1.57;	//pi/2
  float * angle = (base_addr+24);
  *angle = *(base_addr+5)*(*tilt_addr);	//pi/2
  //float * goomba = &goomba_addr;
  //float *tmp = base_addr+5;
  
  //*tmp = 0;
  
  if( **goomba_addr != *tmp)
  {
	//COSINE!
	float cosx = fabs((*angle)*(*angle)*(*angle));
	*tmp = 12.0;
	cosx = cosx/(*tmp);
	*tmp = 1.0;
	cosx = *tmp + cosx; //cosx = 1+a^3/12;
	*tmp = 2.0;
	cosx = cosx - (*angle)*(*angle)/(*tmp); //finito
	
	*tmp = 0.0;
	*tmp2 = 1.0;
	if(*(*goomba_addr + 157) == *tmp)
	{
	  *dist += *tmp2;
	}
    
	//SINE
	*tmp = 7.0;
	*tmp2 = 1.0;
	float sinx = (*angle)* (*tmp2 - (*angle)*(*angle)/(*tmp));
	
	*tmp = 20.0;
	float marioy = *(player_addr + 44);
	*tmp2 = marioy + (*dist) * sinx;
	*(*goomba_addr + 44) = *tmp2;
	*tmp = 15.0;
	*(*goomba_addr + 44) = *(*goomba_addr + 44) + *tmp;
	float goombay = *(*goomba_addr + 44);

	//check direction of mario!
	//float dir = *(player_addr + 64);
	//*tmpint = 0x0000d000;
	//*tmpint = (int)*(player_addr + 64);
	//*tmpint = (int)*(0x8154b904);
	*tmpint = *(player_dir_addr);
	*tmp = 20.0;
    float mariox = *(player_addr + 43);
	
	if(*tmpint == 0x00003000) //stands to the right
	  *tmp2 = mariox + (*dist) * cosx;
	else
	  *tmp2 = mariox - (*dist) * cosx;
	
	  
	*(*goomba_addr + 43) = *tmp2;
	float * goombax = (*goomba_addr + 43);
	
	//continue moving the guide outwards until it hits a wall!
	//float * dist = (float*)(base_addr+10);
	//*dist = fsqrt(mariox*mariox + marioy*marioy);
	//*dist = sqrt((goombax-mariox)*(goombax-mariox) + (goombax-mariox)*(goombax-mariox));
  }
  
  //increase timer
  *tmpint = 1.0;
  *portal_timer += *tmpint;
  
  *tmpint = 2;
  if(*curr_portal == *tmpint) //place first portal
  {
    int ** first_portal = (int**)(base_addr);
	*tmpint = 0x85;
    if(*(*first_portal+2) == *tmpint) //it's a bobomb!
	  {
	    
	    
	  }
  }
  
  
}

