 <%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%

	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String s_user =  request.getParameter("s_month")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
    String dt		= "4";

	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
//비용캠페인변수 : cost_campaign 테이블
	Hashtable ht3 = ac_db.getCostCampaignVar("2");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");

	int amt1 			= AddUtil.parseInt((String)ht3.get("AMT1"));  //일반정비비 한도
	int amt1_per 		= AddUtil.parseInt((String)ht3.get("AMT1_PER")); //한도
	int amt2 			= AddUtil.parseInt((String)ht3.get("AMT2"));  //사고수리비 한도
	int amt2_per 		= AddUtil.parseInt((String)ht3.get("AMT2_PER")); //한도
	int amt3 			= AddUtil.parseInt((String)ht3.get("AMT3"));
	int amt3_per		= AddUtil.parseInt((String)ht3.get("AMT3_PER")); //사고수리비 적용율
	int rent_way_1_per 		= AddUtil.parseInt((String)ht3.get("RENT_WAY_1_PER"));
	int rent_way_2_per 	= AddUtil.parseInt((String)ht3.get("RENT_WAY_2_PER"));
	int max_day			= AddUtil.parseInt((String)ht3.get("MAX_DAY"));
	
	int cam_per 		= AddUtil.parseInt((String)ht3.get("CAM_PER"));
	int a_cam_per 		= AddUtil.parseInt((String)ht3.get("A_CAM_PER"));
	
	int cc1 			= AddUtil.parseInt((String)ht3.get("CC1"));
	int cc2	 			= AddUtil.parseInt((String)ht3.get("CC2"));
	int cc3 			= AddUtil.parseInt((String)ht3.get("CC3"));
	int cc4 			= AddUtil.parseInt((String)ht3.get("CC4"));
	
	int da_amt1 		= AddUtil.parseInt((String)ht3.get("DA_AMT1"));
	int da_amt2 		= AddUtil.parseInt((String)ht3.get("DA_AMT2"));
	int da_amt3 		= AddUtil.parseInt((String)ht3.get("DA_AMT3"));
	
	int bus_cost_per 		= AddUtil.parseInt((String)ht3.get("BUS_COST_PER"));
	int mng_cost_per 		= AddUtil.parseInt((String)ht3.get("MNG_COST_PER"));
	
	int car_cnt 		= AddUtil.parseInt((String)ht3.get("CAR_CNT"));
	int sale_cnt 		= AddUtil.parseInt((String)ht3.get("SALE_CNT"));	
	int base_cnt 		= AddUtil.parseInt((String)ht3.get("BASE_CNT"));	
		
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDtChk("stat_bus_cost_2_cmp" , "2");
		
	Vector vts2 = ac_db.getCostManCampaignNew2(save_dt, "2", base_cnt , "", "");
	int vt_size2 = vts2.size(); 
					
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--


//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}	


//프린트하기
function cmp_print(){
	window.open("man_cost3_settle_print.jsp?save_dt=<%=save_dt%>&auth_rw=<%=auth_rw%>","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
}

//-->
</script>
</head>

<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 
<input type="hidden" name="gubun" value="2"> 
<input type="hidden" name="from_page" value="/fms2/mis/man_cost3_settle.jsp"> 
<input type="hidden" name="save_dt" value="<%=save_dt%>"> 
<input type="hidden" name="year" value="<%=year%>"> 
<input type="hidden" name="tm" value="<%=tm%>">
<input type="hidden" name="a_cam_per" value="<%=a_cam_per%>">  
<input type="hidden" name="o_cs_dt" 	value="<%=cs_dt%>">
<input type="hidden" name="o_ce_dt" 	value="<%=ce_dt%>">
<input type="hidden" name="bus_cost_per" value="<%=bus_cost_per%>"> 
<input type="hidden" name="mng_cost_per" value="<%=mng_cost_per%>"> 

<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > <span class=style5>관리비용절감캠페인(2군)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_campaign.gif align=absmiddle>&nbsp;
        <input type="text" name="ccs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
        ~ 
        <input type="text" name="cce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
    </tr>
</table>
<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><div align="right"><img src=/acar/images/center/arrow_gjij.gif align=absmiddle> : <%=AddUtil.ChangeDate2(save_dt)%></div></td>
    </tr>
</table>
 
<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
 	  <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='900'>
         <tr> 
           <td width='40' class='title' rowspan=2>순위</td>
           <td width='90' class='title' rowspan=2>부서</td>
           <td width='70' class='title' rowspan=2>성명</td>
           <td class='title' colspan=3 >캠페인대수</td>
           <td width='100' class='title' rowspan=2>1대당 월평균<br>관리비용 </td>
           <td width='100' class='title' rowspan=2>포상<br>금액 </td>	
           <td width="320" rowspan="2">
        			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
        				<tr style='text-align:right'>
        				  <td class="title_p" width="320" style='height:44; text-align=center;'>그래프</td>
        				</tr>
        			  </table>
        	</td>
          </tr>
          <tr> 
           <td  width="60" class='title' >기본식</td>
           <td  width="60" class='title' >일반식</td>
           <td  width="60" class='title' >소계</td>
          </tr>
       
	  
<%	if(vt_size2 > 0){
	   
     	long t_cnt[] = new long[1];
    	long i_cnt[] = new long[1];
   		long b_cnt[] = new long[1];
   	
   		/*
   	   	long t_amt1[] = new long[1]; //정비비(일반식)
      	long t_amt2[] = new long[1]; //as(기본식)
        long t_amt3[] = new long[1]; //사고수리비(일반식)
        long t_amt4[] = new long[1]; //탁송료(일반식)
        long t_amt5[] = new long[1];  //카드유류대(공통)
        long t_amt6[] = new long[1]; //활동비유류대(공통)
        long t_amt7[] = new long[1]; //통신비(공통)
        long t_amt8[] = new long[1]; //교통비(공통)
        long t_amt9[] = new long[1]; //대차비용계(일반식+기본식)
        long t_amt10[] = new long[1];  //정비비(일반식정비비+기본식정비비)
        long t_amt11[] = new long[1];  //휴/대차료(일반식)
        long t_amt12[] = new long[1];  //정비비(기본식) 
        long t_amt13[] = new long[1];  //사고수리비(기본식) 
        long t_amt14[] = new long[1];   //사고수리비계(일반식+기본식)
        long t_amt15[] = new long[1];  //탁송유류비(일반식)
        long t_amt16[] = new long[1];  //탁송유류비(기본식)
        long t_amt17[] = new long[1];  //유류비계(카드유류대+탁송유류대(일반+기본)) 
        long t_amt18[] = new long[1];   //탁송료(기본식)
        long t_amt19[] = new long[1];   //탁송료계(일반식+기본식)
        long t_amt20[] = new long[1];  //휴대차료(기본식)
        long t_amt21[] = new long[1];  //대차비용(일반식)
        long t_amt22[] = new long[1];  //대차비용(기본식)
        long t_amt23[] = new long[1];  //휴대차료계
        long t_amt24[] = new long[1];  //as재리스(일반식)
        long t_amt25[] = new long[1];  //as재리스(일반식+기본식)
        long t_amt26[] = new long[1];  //긴급출동
    	*/
    	
	    long bb_cnt = 0;
	    long ii_cnt = 0 ;
	    long iii_cnt = 0 ;
	    long cc_amt = 0 ;
	    
	    long s_tot = 0;
	    long g_tot = 0;
	    long ccnt  = 0;
	
	    long ave_amt1 = 0;
	    long ave_amt2 = 0;
	    long t_ave_amt = 0;
	               
	    long ac_amt = 0;
	    long a_amt = 0;
	    long ea_amt = 0;
    	
    	long cam_amt = 0;	
   		long sum_cam_amt = 0;	
	       
     	for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
			
			
				ii_cnt = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
				bb_cnt = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
				
				for(int j=0; j<1; j++){
											
					i_cnt[j] += ii_cnt;
					b_cnt[j] += bb_cnt;
				}				
						
			    // 상품별대수비율 감안한 1대당비용
			    t_ave_amt = AddUtil.parseLong(String.valueOf(ht.get("ONE_PER_COST")));
			    ave_amt2 =  AddUtil.parseLong(String.valueOf(ht.get("R_ONE_PER_COST")));
			    	    
			    cam_amt  =  AddUtil.parseLong(String.valueOf(ht.get("P_AMT")));
			    
			    if ( ht.get("PO").equals("9") )    	cam_amt = 0;
			
			  
			   // cam_amt = (t_ave_amt - ave_amt2) * (ii_cnt + bb_cnt) ;
				
		       // if (cam_amt < 0 ) {
		      //	 	cam_amt = 0;
		       //  }	 
					
					       		     		     		         
		        //cam_amt	= cam_amt *  cam_per/100 ; 
		        
		       // if (cam_amt > 0 && cam_amt < 120000){
		        // cam_amt = 120000;
		       // } 
		       
		      //  cam_amt = AddUtil.ml_th_rnd((int)cam_amt);
		         
		        sum_cam_amt +=cam_amt; 
   		
   		   		
		   		float graph = 160;
		   		float  g1 = (float) ave_amt2*160 / t_ave_amt;
		   			  		
		  		if (ave_amt2 > t_ave_amt ) {
		  		   graph =  g1  - 160;
		  //		   System.out.println("graph1=" +graph);
		  		} else {
		  		  graph =  160 - g1;
		  	//	  System.out.println("graph1=" +graph);
		  		}
		  		
		  	//	if (ave_amt2 > t_ave_amt ) {
		  	
		  	   //max:160 
		  		  if (graph >= 160) {
		  		  	graph = 160;
		  	//	  	System.out.println("graph2=" +graph);
		  		  }
		  	 //  	}	
		  	   	
		  	   		   		
		   		//result1: 빨간색 resul2:파란색 result3:흰색		   				  				   		
	//	   		System.out.println("ave_amt2= " + ave_amt2 + " g1= " +g1 + " g2 =   graph= " + graph); 		   		

 %>   		
	      <tr>
	         <input type='hidden' name='bus_id' value='<%= ht.get("USER_ID") %>'>
	         <input type='hidden' name='p_amt' value='<%=cam_amt%>'> 
	      	 <td align="center" ><%= i+1%></td>
	         <td align="center" ><%=c_db.getNameById(String.valueOf(ht.get("DEPT_ID")), "DEPT")%>&nbsp;</td>
	         <td align="center" ><%=ht.get("USER_NM")%>&nbsp;<!--<a href="javascript:MM_openBrWindow('man_cost_jung_detail_list.jsp?mng_id=<%= ht.get("USER_ID") %>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&mng_nm=<%=ht.get("USER_NM")%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>','popwin_list','scrollbars=yes,status=no,resizable=yes,width=900,height=560,top=30,left=30')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>--></td>
	         <td align="right" ><%=bb_cnt%>&nbsp;</td>
	         <td align="right" ><%=ii_cnt%>&nbsp;</td>
	         <td align="right" ><%=ii_cnt + bb_cnt%>&nbsp;</td>
	         <td align="right"><%=Util.parseDecimal(ave_amt2)%>&nbsp;</td>    		
	         <td align="right"><%=Util.parseDecimal(cam_amt)%>&nbsp;</td>
	         </td>    
	         <td align="">
	          <table width="320" border="0" cellspacing="0" cellpadding="0">
<% if (ht.get("PO").equals("9")  ) {%> 	    
	         <tr>
	           	<td width=160>미적용 (기준대수 미만)</td>	
	         	<td width=160></td>	 
<% } else if (ht.get("PO").equals("8")  ) {%>
   <tr>
	           	<td width=160>미적용 (장기휴가)</td>	
	         	<td width=160></td>	
<% } else  {%> 	        
<% if (ave_amt2 > t_ave_amt ) { %>	         
	         <tr>
	         	<td width=160></td>	 
	         	<td width=160><img src=../../images/result1.gif width=<%= graph %> height=10></td>	
	       	 </tr>
<% } else { %>
 		 <tr>
	           	<td width=160><img src=../../images/result3.gif width=<%= g1 %> height=10><img src=../../images/result2.gif width=<%= graph %> height=10></td>	
	         	<td width=160></td>	 
	       	 </tr>
<% } %>	 
<% } %>
	       	 </table>        
	      </tr>
	   <% 	} %>

	      <tr> 
	        <td class=title style='text-align:center;' colspan=3>합계</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(b_cnt[0])%>&nbsp;</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(i_cnt[0])%>&nbsp;</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(b_cnt[0] + i_cnt[0])%>&nbsp;</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_ave_amt) %>&nbsp;</td>
	 		<td class=title style='text-align:right;'><%= Util.parseDecimal(sum_cam_amt)%>&nbsp;</td>
	        <td class=title style='text-align:left;'>&nbsp;미적용 제외</td>
	      </tr>		
        
 
<%	}else{%>   
                  
  <tr>
	  <td> 
	   <table width="900" border="0" cellspacing="0" cellpadding="0">
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>

   </table>
    </td>
  </tr>
</table>
 
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
			   	    
	}	
//-->
</script>		
</body>
</html>

