package acar.admin;

import java.util.*;

public class StatBusCmpBean {
    //Table : STAT_BUS_CMP
    private String save_dt			;
	private String seq				;
    private String bus_id			;
	private String rent_cnt			;
	private String start_cnt		;				
	private String cnt1				;	 	
	private String r_rent_cnt		;  	
	private String r_start_cnt		;  	
    private String r_cnt			;     	
	private String day				; 	
    private String r_cnt2			; 		
	private String pre_cmp			; 			
	private String pre_cmp_ga		;  		
	private String c_day			;  	
	private String cmp_discnt_per	;  	
	private String c_rent_cnt		;  	
    private String c_start_cnt		;  	
	private String c_cnt			;			
    private String cr_rent_cnt		;  	
	private String cr_start_cnt		;  		
	private String cr_cnt			;			
	private String dalsung			;  	
	private String org_dalsung		;  	
	private String amt				;  	
	private String avg_dalsung		;  	
    private String amt2				;		
	private String sum_cnt1			;  	
    private String sum_r_cnt		;  	
	private String sum_bus			;				
	private String avg_cnt1			;  		
	private String avg_r_cnt		;  	
	private String avg_bus			;  	
	private String avg_low_bus		;  	
	private String v_bs_dt			;  	
	private String v_be_dt			;
	private String v_bs_dt2			;
    private String v_be_dt2			;
	private String v_cs_dt			;
    private String v_ce_dt			;
	private String v_car_amt		;
	private String v_bus_up_per		;
	private String v_bus_down_per	;
	private String v_mng_up_per		;
	private String v_mng_down_per	;
    private String v_bus_amt_per	;
	private String v_mng_amt_per	;
    private String v_cnt1			;
	private String v_mon			;
	private String v_cnt2			;
	private String v_cmp_discnt_per	;
	private String v_max_dalsung	;
	private String v_bus_ga			;
	private String v_mng_ga			;
	private String v_bus_new_ga		;
	private String v_enter_dt		;
	private String v_ns_dt1			;				
	private String v_ne_dt1			;				
	private String v_nm_cnt1		;				
	private String v_nb_cnt1		;				
	private String v_ns_dt2			;				
	private String v_ne_dt2			;				
	private String v_nm_cnt2		;				
	private String v_nb_cnt2		;				
	private String v_ns_dt3			;				
	private String v_ne_dt3			;				
	private String v_nm_cnt3		;				
	private String v_nb_cnt3		;	

	private String day2				; 		
    private String r_cnt2_1			; 		
    private String r_cnt2_2			; 	
	private String r_cost_cnt		;  	
	private String c_cost_cnt		;  	
    private String sum_cost_cnt		;  	
	private String sum_bus_1		;				
	private String sum_bus_2		;				
	private String avg_cost_cnt		;  	
	private String avg_bus_1		;  	
	private String avg_bus_2		;  	
	private String c_tot_cnt		;  	
	private String v_cnt_per		;				
	private String v_cost_per		;	
	private String avg_car_cost_1	;  	
	private String avg_car_cost_2	;  	
	private String r_cost_amt		;  	
	private String c_cost_amt		;  	
	private String cost_cnt1		;  	
	private String cost_cnt2		;  		
	private String v_car_amt2		;
	private String v_cnt_per2		;				
	private String v_cost_per2		;	
	private String v_max_dalsung2	;

	
	public StatBusCmpBean() {  
		this.save_dt			= ""; 
		this.seq				= "";  
		this.bus_id				= "";  
		this.rent_cnt			= ""; 
		this.start_cnt			= ""; 	
		this.cnt1				= ""; 	
		this.r_rent_cnt			= "";  
		this.r_start_cnt		= "";  
		this.r_cnt				= "";  
		this.day				= "";  
		this.r_cnt2				= "";  
		this.pre_cmp			= "";  
		this.pre_cmp_ga			= "";  
		this.c_day				= "";  
		this.cmp_discnt_per		= "";  
		this.c_rent_cnt			= "";  
		this.c_start_cnt		= "";  
		this.c_cnt				= ""; 	
		this.cr_rent_cnt		= "";  
		this.cr_start_cnt		= "";  
		this.cr_cnt				= ""; 	
		this.dalsung			= "";  
		this.org_dalsung		= "";  
		this.amt				= ""; 
		this.avg_dalsung		= ""; 
		this.amt2				= ""; 
		this.sum_cnt1			= ""; 
		this.sum_r_cnt			= ""; 
		this.sum_bus			= ""; 
		this.avg_cnt1			= ""; 
		this.avg_r_cnt			= ""; 
		this.avg_bus			= ""; 
		this.avg_low_bus		= ""; 
		this.v_bs_dt			= ""; 
		this.v_be_dt			= ""; 
		this.v_bs_dt2			= ""; 
		this.v_be_dt2			= ""; 
		this.v_cs_dt			= ""; 
		this.v_ce_dt			= ""; 
		this.v_car_amt			= ""; 
		this.v_bus_up_per		= ""; 
		this.v_bus_down_per		= ""; 
		this.v_mng_up_per		= ""; 
		this.v_mng_down_per		= ""; 
		this.v_bus_amt_per		= ""; 
		this.v_mng_amt_per		= ""; 
		this.v_cnt1				= ""; 
		this.v_mon				= ""; 
		this.v_cnt2				= ""; 
		this.v_cmp_discnt_per	= ""; 
		this.v_max_dalsung		= ""; 
		this.v_bus_ga			= ""; 
		this.v_mng_ga			= ""; 
		this.v_bus_new_ga		= ""; 
		this.v_enter_dt			= ""; 
		this.v_ns_dt1			= ""; 
		this.v_ne_dt1			= ""; 
		this.v_nm_cnt1			= ""; 
		this.v_nb_cnt1			= ""; 
		this.v_ns_dt2			= ""; 
		this.v_ne_dt2			= ""; 
		this.v_nm_cnt2			= ""; 
		this.v_nb_cnt2			= ""; 
		this.v_ns_dt3			= ""; 
		this.v_ne_dt3			= ""; 
		this.v_nm_cnt3			= ""; 
		this.v_nb_cnt3			= ""; 

		this.day2				= "";  
		this.r_cnt2_1			= "";  
		this.r_cnt2_2			= "";  
		this.r_cost_cnt			= "";  
		this.c_cost_cnt			= "";  
		this.sum_cost_cnt		= ""; 
		this.sum_bus_1			= ""; 
		this.sum_bus_2			= ""; 
		this.avg_cost_cnt		= ""; 
		this.avg_bus_1			= ""; 
		this.avg_bus_2			= ""; 
		this.c_tot_cnt			= ""; 
		this.v_cnt_per			= ""; 
		this.v_cost_per			= ""; 
		this.avg_car_cost_1		= ""; 
		this.avg_car_cost_2		= ""; 
		this.r_cost_amt			= "";  
		this.c_cost_amt			= "";  
		this.cost_cnt1			= "";  
		this.cost_cnt2			= "";  
		
		this.v_car_amt2			= ""; 
		this.v_cnt_per2			= ""; 
		this.v_cost_per2		= ""; 
		this.v_max_dalsung2		= ""; 



	}							 
								 
	// set Method
	public void setSave_dt			(String val){		if(val==null) val=""; this.save_dt				= val;}
	public void setSeq				(String val){		if(val==null) val=""; this.seq					= val;}
	public void setBus_id			(String val){		if(val==null) val=""; this.bus_id				= val;}
	public void setRent_cnt			(String val){		if(val==null) val=""; this.rent_cnt				= val;}
	public void setStart_cnt		(String val){		if(val==null) val=""; this.start_cnt			= val;}
	public void setCnt1				(String val){		if(val==null) val=""; this.cnt1					= val;}
	public void setR_rent_cnt		(String val){		if(val==null) val=""; this.r_rent_cnt			= val;}
	public void setR_start_cnt		(String val){		if(val==null) val=""; this.r_start_cnt			= val;}
	public void setR_cnt			(String val){		if(val==null) val=""; this.r_cnt				= val;}
	public void setDay				(String val){		if(val==null) val=""; this.day					= val;}
	public void setR_cnt2			(String val){		if(val==null) val=""; this.r_cnt2				= val;}
	public void setPre_cmp			(String val){		if(val==null) val=""; this.pre_cmp				= val;}
	public void setPre_cmp_ga		(String val){		if(val==null) val=""; this.pre_cmp_ga			= val;}
	public void setC_day			(String val){		if(val==null) val=""; this.c_day				= val;}
	public void setCmp_discnt_per	(String val){		if(val==null) val=""; this.cmp_discnt_per		= val;}
	public void setC_rent_cnt		(String val){		if(val==null) val=""; this.c_rent_cnt			= val;}
	public void setC_start_cnt		(String val){		if(val==null) val=""; this.c_start_cnt			= val;}
	public void setC_cnt			(String val){		if(val==null) val=""; this.c_cnt				= val;}
	public void setCr_rent_cnt		(String val){		if(val==null) val=""; this.cr_rent_cnt			= val;}
	public void setCr_start_cnt		(String val){		if(val==null) val=""; this.cr_start_cnt			= val;}
	public void setCr_cnt			(String val){		if(val==null) val=""; this.cr_cnt				= val;}
	public void setDalsung			(String val){		if(val==null) val=""; this.dalsung				= val;}
	public void setAmt				(String val){		if(val==null) val=""; this.amt					= val;}
	public void setAvg_dalsung		(String val){		if(val==null) val=""; this.avg_dalsung			= val;}
	public void setAmt2				(String val){		if(val==null) val=""; this.amt2					= val;}
	public void setSum_cnt1			(String val){		if(val==null) val=""; this.sum_cnt1				= val;}
	public void setSum_r_cnt		(String val){		if(val==null) val=""; this.sum_r_cnt			= val;}
	public void setSum_bus			(String val){		if(val==null) val=""; this.sum_bus				= val;}
	public void setAvg_cnt1			(String val){		if(val==null) val=""; this.avg_cnt1				= val;}
	public void setAvg_r_cnt		(String val){		if(val==null) val=""; this.avg_r_cnt			= val;}
	public void setAvg_bus			(String val){		if(val==null) val=""; this.avg_bus				= val;}
	public void setAvg_low_bus		(String val){		if(val==null) val=""; this.avg_low_bus			= val;}
	public void setV_bs_dt			(String val){		if(val==null) val=""; this.v_bs_dt				= val;}
	public void setV_be_dt			(String val){		if(val==null) val=""; this.v_be_dt				= val;}
	public void setV_bs_dt2			(String val){		if(val==null) val=""; this.v_bs_dt2				= val;}
	public void setV_be_dt2			(String val){		if(val==null) val=""; this.v_be_dt2				= val;}
	public void setV_cs_dt			(String val){		if(val==null) val=""; this.v_cs_dt				= val;}
	public void setV_ce_dt			(String val){		if(val==null) val=""; this.v_ce_dt				= val;}
	public void setV_car_amt		(String val){		if(val==null) val=""; this.v_car_amt			= val;}
	public void setV_bus_up_per		(String val){		if(val==null) val=""; this.v_bus_up_per			= val;}
	public void setV_bus_down_per	(String val){		if(val==null) val=""; this.v_bus_down_per		= val;}
	public void setV_mng_up_per		(String val){		if(val==null) val=""; this.v_mng_up_per			= val;}
	public void setV_mng_down_per	(String val){		if(val==null) val=""; this.v_mng_down_per		= val;}
	public void setV_bus_amt_per	(String val){		if(val==null) val=""; this.v_bus_amt_per		= val;}
	public void setV_mng_amt_per	(String val){		if(val==null) val=""; this.v_mng_amt_per		= val;}
	public void setV_cnt1			(String val){		if(val==null) val=""; this.v_cnt1				= val;}
	public void setV_mon			(String val){		if(val==null) val=""; this.v_mon				= val;}
	public void setV_cnt2			(String val){		if(val==null) val=""; this.v_cnt2				= val;}
	public void setV_cmp_discnt_per	(String val){		if(val==null) val=""; this.v_cmp_discnt_per		= val;}
	public void setV_max_dalsung	(String val){		if(val==null) val=""; this.v_max_dalsung		= val;}
	public void setV_bus_ga			(String val){		if(val==null) val=""; this.v_bus_ga				= val;}
	public void setV_mng_ga			(String val){		if(val==null) val=""; this.v_mng_ga				= val;}
	public void setV_bus_new_ga		(String val){		if(val==null) val=""; this.v_bus_new_ga			= val;}
	public void setV_enter_dt		(String val){		if(val==null) val=""; this.v_enter_dt			= val;}
	public void setOrg_dalsung		(String val){		if(val==null) val=""; this.org_dalsung			= val;}
	public void setV_ns_dt1			(String val){		if(val==null) val=""; this.v_ns_dt1				= val;}
	public void setV_ne_dt1			(String val){		if(val==null) val=""; this.v_ne_dt1				= val;}
	public void setV_nm_cnt1		(String val){		if(val==null) val=""; this.v_nm_cnt1			= val;}
	public void setV_nb_cnt1		(String val){		if(val==null) val=""; this.v_nb_cnt1			= val;}
	public void setV_ns_dt2			(String val){		if(val==null) val=""; this.v_ns_dt2				= val;}
	public void setV_ne_dt2			(String val){		if(val==null) val=""; this.v_ne_dt2				= val;}
	public void setV_nm_cnt2		(String val){		if(val==null) val=""; this.v_nm_cnt2			= val;}
	public void setV_nb_cnt2		(String val){		if(val==null) val=""; this.v_nb_cnt2			= val;}
	public void setV_ns_dt3			(String val){		if(val==null) val=""; this.v_ns_dt3				= val;}
	public void setV_ne_dt3			(String val){		if(val==null) val=""; this.v_ne_dt3				= val;}
	public void setV_nm_cnt3		(String val){		if(val==null) val=""; this.v_nm_cnt3			= val;}
	public void setV_nb_cnt3		(String val){		if(val==null) val=""; this.v_nb_cnt3			= val;}
	public void setDay2				(String val){		if(val==null) val=""; this.day2					= val;}
	public void setR_cnt2_1			(String val){		if(val==null) val=""; this.r_cnt2_1				= val;}
	public void setR_cnt2_2			(String val){		if(val==null) val=""; this.r_cnt2_2				= val;}
	public void setR_cost_cnt		(String val){		if(val==null) val=""; this.r_cost_cnt			= val;}
	public void setC_cost_cnt		(String val){		if(val==null) val=""; this.c_cost_cnt			= val;}
	public void setSum_cost_cnt		(String val){		if(val==null) val=""; this.sum_cost_cnt			= val;}
	public void setSum_bus_1		(String val){		if(val==null) val=""; this.sum_bus_1			= val;}
	public void setSum_bus_2		(String val){		if(val==null) val=""; this.sum_bus_2			= val;}
	public void setAvg_cost_cnt		(String val){		if(val==null) val=""; this.avg_cost_cnt			= val;}
	public void setAvg_bus_1		(String val){		if(val==null) val=""; this.avg_bus_1			= val;}
	public void setAvg_bus_2		(String val){		if(val==null) val=""; this.avg_bus_2			= val;}
	public void setC_tot_cnt		(String val){		if(val==null) val=""; this.c_tot_cnt			= val;}
	public void setV_cnt_per		(String val){		if(val==null) val=""; this.v_cnt_per			= val;}
	public void setV_cost_per		(String val){		if(val==null) val=""; this.v_cost_per			= val;}
	public void setAvg_car_cost_1	(String val){		if(val==null) val=""; this.avg_car_cost_1		= val;}
	public void setAvg_car_cost_2	(String val){		if(val==null) val=""; this.avg_car_cost_2		= val;}
	public void setR_cost_amt		(String val){		if(val==null) val=""; this.r_cost_amt			= val;}
	public void setC_cost_amt		(String val){		if(val==null) val=""; this.c_cost_amt			= val;}
	public void setCost_cnt1		(String val){		if(val==null) val=""; this.cost_cnt1			= val;}
	public void setCost_cnt2		(String val){		if(val==null) val=""; this.cost_cnt2			= val;}

	public void setV_car_amt2		(String val){		if(val==null) val=""; this.v_car_amt2			= val;}
	public void setV_cnt_per2		(String val){		if(val==null) val=""; this.v_cnt_per2			= val;}
	public void setV_cost_per2		(String val){		if(val==null) val=""; this.v_cost_per2			= val;}
	public void setV_max_dalsung2	(String val){		if(val==null) val=""; this.v_max_dalsung2		= val;}

	//Get Method
	public String getSave_dt			(){				return save_dt			;}
    public String getSeq				(){				return seq				;}
    public String getBus_id				(){				return bus_id			;}
	public String getRent_cnt			(){				return rent_cnt			;}
	public String getStart_cnt			(){				return start_cnt		;}
	public String getCnt1				(){				return cnt1				;}
    public String getR_rent_cnt			(){				return r_rent_cnt		;}
    public String getR_start_cnt		(){				return r_start_cnt		;}
	public String getR_cnt				(){				return r_cnt			;}
	public String getDay				(){				return day				;}
	public String getR_cnt2				(){				return r_cnt2			;}
    public String getPre_cmp			(){				return pre_cmp			;}
    public String getPre_cmp_ga			(){				return pre_cmp_ga		;}
	public String getC_day				(){				return c_day			;}
	public String getCmp_discnt_per		(){				return cmp_discnt_per	;}
	public String getC_rent_cnt			(){				return c_rent_cnt		;}
    public String getC_start_cnt		(){				return c_start_cnt		;}
    public String getC_cnt				(){				return c_cnt			;}
	public String getCr_rent_cnt		(){				return cr_rent_cnt		;}
	public String getCr_start_cnt		(){				return cr_start_cnt		;}
	public String getCr_cnt				(){				return cr_cnt			;}
    public String getDalsung			(){				return dalsung			;}
    public String getAmt				(){				return amt				;}
	public String getAvg_dalsung		(){				return avg_dalsung		;}
	public String getAmt2				(){				return amt2				;}
	public String getSum_cnt1			(){				return sum_cnt1			;}
    public String getSum_r_cnt			(){				return sum_r_cnt		;}
    public String getSum_bus			(){				return sum_bus			;}
	public String getAvg_cnt1			(){				return avg_cnt1			;}
	public String getAvg_r_cnt			(){				return avg_r_cnt		;}
	public String getAvg_bus			(){				return avg_bus			;}
    public String getAvg_low_bus		(){				return avg_low_bus		;}
    public String getV_bs_dt			(){				return v_bs_dt			;}
	public String getV_be_dt			(){				return v_be_dt			;}
	public String getV_bs_dt2			(){				return v_bs_dt2			;}
	public String getV_be_dt2			(){				return v_be_dt2			;}
    public String getV_cs_dt			(){				return v_cs_dt			;}
    public String getV_ce_dt			(){				return v_ce_dt			;}
	public String getV_car_amt			(){				return v_car_amt		;}
	public String getV_bus_up_per		(){				return v_bus_up_per		;}
	public String getV_bus_down_per		(){				return v_bus_down_per	;}
    public String getV_mng_up_per		(){				return v_mng_up_per		;}
    public String getV_mng_down_per		(){				return v_mng_down_per	;}
	public String getV_bus_amt_per		(){				return v_bus_amt_per	;}
	public String getV_mng_amt_per		(){				return v_mng_amt_per	;}
	public String getV_cnt1				(){				return v_cnt1			;}
    public String getV_mon				(){				return v_mon			;}
    public String getV_cnt2				(){				return v_cnt2			;}
	public String getV_cmp_discnt_per	(){				return v_cmp_discnt_per	;}
	public String getV_max_dalsung		(){				return v_max_dalsung	;}
	public String getV_bus_ga			(){				return v_bus_ga			;}
    public String getV_mng_ga			(){				return v_mng_ga			;}
    public String getV_bus_new_ga		(){				return v_bus_new_ga		;}
    public String getV_enter_dt			(){				return v_enter_dt		;}
    public String getOrg_dalsung		(){				return org_dalsung		;}
	public String getV_ns_dt1			(){				return v_ns_dt1			;}
	public String getV_ne_dt1			(){				return v_ne_dt1			;}
	public String getV_nm_cnt1			(){				return v_nm_cnt1		;}
    public String getV_nb_cnt1			(){				return v_nb_cnt1		;}
    public String getV_ns_dt2			(){				return v_ns_dt2			;}
	public String getV_ne_dt2			(){				return v_ne_dt2			;}
	public String getV_nm_cnt2			(){				return v_nm_cnt2		;}
	public String getV_nb_cnt2			(){				return v_nb_cnt2		;}
    public String getV_ns_dt3			(){				return v_ns_dt3			;}
    public String getV_ne_dt3			(){				return v_ne_dt3			;}
    public String getV_nm_cnt3			(){				return v_nm_cnt3		;}
    public String getV_nb_cnt3			(){				return v_nb_cnt3		;}
	public String getDay2				(){				return day2				;}
	public String getR_cnt2_1			(){				return r_cnt2_1			;}
	public String getR_cnt2_2			(){				return r_cnt2_2			;}
	public String getR_cost_cnt			(){				return r_cost_cnt		;}
	public String getC_cost_cnt			(){				return c_cost_cnt		;}
    public String getSum_cost_cnt		(){				return sum_cost_cnt		;}
    public String getSum_bus_1			(){				return sum_bus_1		;}
    public String getSum_bus_2			(){				return sum_bus_2		;}
	public String getAvg_cost_cnt		(){				return avg_cost_cnt		;}
	public String getAvg_bus_1			(){				return avg_bus_1		;}
	public String getAvg_bus_2			(){				return avg_bus_2		;}
	public String getC_tot_cnt			(){				return c_tot_cnt		;}
    public String getV_cnt_per			(){				return v_cnt_per		;}
    public String getV_cost_per			(){				return v_cost_per		;}
	public String getAvg_car_cost_1		(){				return avg_car_cost_1	;}
	public String getAvg_car_cost_2		(){				return avg_car_cost_2	;}
	public String getR_cost_amt			(){				return r_cost_amt		;}
	public String getC_cost_amt			(){				return c_cost_amt		;}
	public String getCost_cnt1			(){				return cost_cnt1		;}
	public String getCost_cnt2			(){				return cost_cnt2		;}
	
	public String getV_car_amt2			(){				return v_car_amt2		;}
    public String getV_cnt_per2			(){				return v_cnt_per2		;}
    public String getV_cost_per2		(){				return v_cost_per2		;}
	public String getV_max_dalsung2		(){				return v_max_dalsung2	;}

}