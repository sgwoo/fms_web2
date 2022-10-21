package acar.stat_applet;

import java.util.*;
import acar.util.*;

public class  LastMonth
{

	int count = 0;

	public String getLastDay(String from_day, String to_day) 
	{	

		Calendar from_d = Calendar.getInstance();
		from_d.set(Integer.parseInt(from_day.substring(0, 4)), Integer.parseInt(from_day.substring(4, 6)) -1, 1);	//FROM 		
							
		Calendar to_d = Calendar.getInstance();
		to_d.set(Integer.parseInt(to_day.substring(0, 4)), Integer.parseInt(to_day.substring(4, 6)) - 1, 1);			//to
						
		Calendar next_d = Calendar.getInstance();
		next_d.set(Integer.parseInt(from_day.substring(0, 4)), Integer.parseInt(from_day.substring(4, 6)) - 1, 1);	//next month
		next_d.add(Calendar.YEAR, 1);
		next_d.add(Calendar.MONTH, -1);
		
//		System.out.println(from_d.get(Calendar.YEAR) + "/" + (from_d.get(Calendar.MONTH) + 1) + "/" + (from_d.get(Calendar.DATE)) + "");
//		System.out.println(to_d.get(Calendar.YEAR) + "/" + (to_d.get(Calendar.MONTH) + 1) + "/" + (to_d.get(Calendar.DATE)) + "");
//		System.out.println(next_d.get(Calendar.YEAR) + "/" + (next_d.get(Calendar.MONTH) + 1) + "/" + (next_d.get(Calendar.DATE)) + "");

/*		while (true) {
			count++;			
			if ((from_d.get(Calendar.YEAR) == to_d.get(Calendar.YEAR)) && 
					((from_d.get(Calendar.MONTH) + 1) == (to_d.get(Calendar.MONTH) + 1))) 
						return Convert.getSizingZero(from_d.get(Calendar.YEAR) + "", 2) + 
									Convert.getSizingZero((from_d.get(Calendar.MONTH) + 1) + "", 2);
			if ((from_d.get(Calendar.YEAR) == next_d.get(Calendar.YEAR)) && 
					((from_d.get(Calendar.MONTH) + 1) == (next_d.get(Calendar.MONTH) + 1))) 
						return Convert.getSizingZero(from_d.get(Calendar.YEAR) + "", 2) + 
									Convert.getSizingZero((from_d.get(Calendar.MONTH) + 1) + "", 2);
			from_d.add(Calendar.MONTH, +1);						
		}
*/
		return Convert.getSizingZero(next_d.get(Calendar.YEAR) + "", 2) + 
									Convert.getSizingZero(next_d.get(Calendar.MONTH) + 1 + "", 2);
	}	

	
	public String addMonth(String from_day, int add) 
	{	
		Calendar from_d = Calendar.getInstance();
		from_d.set(Integer.parseInt(from_day.substring(0, 4)), Integer.parseInt(from_day.substring(4, 6)) -1, 1);		//FROM 									
		from_d.add(Calendar.MONTH, add);
		return Convert.getSizingZero(from_d.get(Calendar.YEAR) + "", 4) + Convert.getSizingZero((from_d.get(Calendar.MONTH) + 1) + "", 2);
	}	

	public String addMonthBar(String from_day, int add) 
	{	
		Calendar from_d = Calendar.getInstance();
		from_d.set(Integer.parseInt(from_day.substring(0, 4)), Integer.parseInt(from_day.substring(4, 6)) -1, 1);		//FROM 									
		from_d.add(Calendar.MONTH, add);
		return Convert.getSizingZero(from_d.get(Calendar.YEAR) + "", 4) +"-"+ Convert.getSizingZero((from_d.get(Calendar.MONTH) + 1) + "", 2);
	}	
	
	public String addYear(String from_day, int add) 
	{	
		Calendar from_d = Calendar.getInstance();
		from_d.set(Integer.parseInt(from_day.substring(0, 4)), Integer.parseInt(from_day.substring(4, 6)) -1, Integer.parseInt(from_day.substring(6, 8)) );		//FROM 									
		from_d.add(Calendar.YEAR, add);
		return Convert.getSizingZero(from_d.get(Calendar.YEAR) + "", 4) + Convert.getSizingZero((from_d.get(Calendar.MONTH) + 1) + "", 2) + Convert.getSizingZero((from_d.get(Calendar.DATE)) + "", 2);
	}	

	public int getDay() {
		return count;
	}
	
	public static void main(String args[])
	{
		LastMonth ld = new LastMonth();
		//System.out.println("°á°ú =>" + ld.getLastDay("0103", "0312"));
		//System.out.println(ld.addMonth("0111", 2));
		//System.out.println(ld.getDay());
	}
	
}
