package acar.common;

/***
 *	차종, 차명 Bean
 */
public class CarNmBean 
{
	
	public String car_comp_id 	= "";
	public String code 			= "";
	public String car_cd 		= "";
	public String car_id 		= "";
	public String car_nm 		= "";
  
	public void setCar_comp_id(String str)	{  car_comp_id = str; }
	public void setCode(String str)			{  code 		= str; }
	public void setCar_cd(String str)		{  car_cd 		= str; }
	public void setCar_id(String str)		{  car_id 		= str; }
	public void setCar_nm(String str)		{  car_nm 		= str; }
	
	public String getCar_comp_id()	{  return car_comp_id; }
	public String getCode()			{  return code; }
	public String getCar_cd()		{  return car_cd; }
	public String getCar_id()		{  return car_id; }
	public String getCar_nm()		{  return car_nm; }
}