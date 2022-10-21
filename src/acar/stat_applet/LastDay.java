package acar.stat_applet;

import java.util.*;

public class  LastDay
{

	int count = 0;
	
	public String getLastDay(String from_day, String to_day) 
	{	
		Calendar from_d = Calendar.getInstance();		
		from_d.set(Integer.parseInt(from_day.substring(0, 4)), 
							Integer.parseInt(from_day.substring(4, 6)) -1,
							Integer.parseInt(from_day.substring(6, 8)) );		//FROM 		
							
		Calendar to_d = Calendar.getInstance();
		to_d.set(Integer.parseInt(to_day.substring(0, 4)),
						Integer.parseInt(to_day.substring(4, 6)) - 1, 
						Integer.parseInt(to_day.substring(6, 8)));		//FROM 	
						
		Calendar next_d = Calendar.getInstance();
		next_d.set(Integer.parseInt(from_day.substring(0, 4)), 
							Integer.parseInt(from_day.substring(4, 6)) - 1,
							Integer.parseInt(from_day.substring(6, 8)));		//FROM 			
		next_d.add(Calendar.MONTH, 1);
		next_d.add(Calendar.DATE, -1);

		while (true) 
		{
			count++;
			
			if ((from_d.get(Calendar.YEAR) == to_d.get(Calendar.YEAR)) && ((from_d.get(Calendar.MONTH) + 1) == (to_d.get(Calendar.MONTH) + 1)) && ((from_d.get(Calendar.DATE)) == (to_d.get(Calendar.DATE)))) 
				return Convert.getSizingZero(from_d.get(Calendar.YEAR) + "", 2) + Convert.getSizingZero((from_d.get(Calendar.MONTH) + 1) + "", 2) + Convert.getSizingZero((from_d.get(Calendar.DATE)) + "", 2);

			if ((from_d.get(Calendar.YEAR) == next_d.get(Calendar.YEAR)) && ((from_d.get(Calendar.MONTH) + 1) == (next_d.get(Calendar.MONTH) + 1)) && ((from_d.get(Calendar.DATE)) == (next_d.get(Calendar.DATE)))) 
				return Convert.getSizingZero(from_d.get(Calendar.YEAR) + "", 2) + Convert.getSizingZero((from_d.get(Calendar.MONTH) + 1) + "", 2) + Convert.getSizingZero((from_d.get(Calendar.DATE)) + "", 2);

			from_d.add(Calendar.DATE, +1);
		}
	}	
	

	public String addDay(String from_day, int add) 
	{	
		Calendar from_d = Calendar.getInstance();		
		from_d.set(Integer.parseInt(from_day.substring(0, 4)), Integer.parseInt(from_day.substring(4, 6)) -1, Integer.parseInt(from_day.substring(6, 8)) );		//FROM 								
		from_d.add(Calendar.DATE, add);
//		System.out.println(from_d.get(Calendar.YEAR) + "/" + (from_d.get(Calendar.MONTH) + 1) + "/" + (from_d.get(Calendar.DATE)) + "");
		return Convert.getSizingZero(from_d.get(Calendar.YEAR) + "", 4) + Convert.getSizingZero((from_d.get(Calendar.MONTH) + 1) + "", 2) + Convert.getSizingZero((from_d.get(Calendar.DATE)) + "", 2);
	}	

	//1개월전 날짜
	public String addMonth(String from_day, int add) 
	{	
		Calendar from_d = Calendar.getInstance();
		from_d.set(Integer.parseInt(from_day.substring(0, 4)), Integer.parseInt(from_day.substring(4, 6)) -1, Integer.parseInt(from_day.substring(6, 8)) );		//FROM 									
		from_d.add(Calendar.MONTH, add);
		return Convert.getSizingZero(from_d.get(Calendar.YEAR) + "", 4) + Convert.getSizingZero((from_d.get(Calendar.MONTH) + 1) + "", 2) + Convert.getSizingZero((from_d.get(Calendar.DATE)) + "", 2);
	}	
	
	public int getDay() {
		return count;
	}

	
	public static void main(String args[])
	{
		LastDay ld = new LastDay();
//		System.out.println(ld.getLastDay("011211", "020111"));
//		System.out.println(ld.addDay("011102", 0));
//		System.out.println(ld.getDay());
	}
	
}
