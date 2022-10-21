<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
 	String s_user =  request.getParameter("s_month")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
   
    String dt		= "4";

	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
//비용캠페인변수 : cost_campaign 테이블
	Hashtable ht3 = ac_db.getCostCampaignVar("1");
	
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
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_bus_cost_cmp");
		
	Vector vts2 = ac_db.getCostManCampaignNew(save_dt, "1", base_cnt, "", "");
	int vt_size2 = vts2.size(); 
			
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--


//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}	

//변수수정
function updateVar(){
	var fm = document.form1;
	if(!confirm("변수값을 수정하시겠습니까?"))	return;	
	
//	fm.action = "/fms2/mis/man_cost_var_iu_2014.jsp";
	fm.target = 'i_no';
	fm.submit();
}

//계산식보기
function view_sik(){
	window.open("man_cost_jung.jsp?popup=Y","sik","left=50,top=50,width=1200,height=650,scrollbars=yes");
}

//-->
</script>
</head>

<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 
<input type="hidden" name="gubun" value="1"> 
<input type="hidden" name="from_page" value="/fms2/mis/man_cost_settle.jsp"> 
<input type="hidden" name="save_dt" value="<%=save_dt%>"> 
<input type="hidden" name="year" value="<%=year%>"> 
<input type="hidden" name="tm" value="<%=tm%>">  

<input type="hidden" name="o_cs_dt" 	value="<%=cs_dt%>">
<input type="hidden" name="o_ce_dt" 	value="<%=ce_dt%>">

<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > <span class=style5>관리비용절감캠페인(1군)</span></span></td>
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
    	      
	    long bb_cnt = 0;
	    long ii_cnt = 0 ;
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
			    
			 //   cam_amt = (t_ave_amt - ave_amt2) * (ii_cnt + bb_cnt) ;
				
		     //   if (cam_amt < 0 ) {
		    //  	 	cam_amt = 0;
		    //     }	 
		       		     		     		         
		    //    cam_amt	= cam_amt *  cam_per/100 ; 
		        
		    //    if (cam_amt > 0 && cam_amt < 120000){
		    //     cam_amt = 120000;
		    //    } 
		       
		   //    cam_amt = AddUtil.ml_th_rnd((int)cam_amt);
		         
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
	         <td align="right" ><%=bb_cnt + ii_cnt%>&nbsp;</td>
	         <td align="right"><%=Util.parseDecimal(ave_amt2)%>&nbsp;</td>    		
	         <td align="right"><%=Util.parseDecimal(cam_amt)%>&nbsp;</td>
	         </td>    
	   	 <td align="">
	          <table width="320" border="0" cellspacing="0" cellpadding="0">
<% if (!ht.get("PO").equals("9")) {%> 	          
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
<% } else {%>
		 <tr>
	           	<td width=160>미적용 (기준대수 미만)</td>	
	         	<td width=160></td>	 
	       	 </tr>
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
<br>
<!-- 평가기준 -->
  <table width="1000" border="0" cellspacing="0" cellpadding="0">
  	<tr> 
      <td colspan=2><font color="#FF00FF">♣ 포상일</font>       : FMS에 데이타 입력시간 등을 고려하여 캠페인 마감일기준 10일 전후로 포상일이 결정됩니다.  
        &nbsp;&nbsp;</td>
   	</tr> 
 <!--  	
   	<tr> 
      <td colspan=2><font color="#FF00FF">♣ 관리비용</font>     : ((기본식평균/전체기본식평균)*(기본식비용/비용(본인))+(일반식평균/전체일반식평균)*(일반식비용/비용(본인)))*1대당평균관리비용(전체비용/전체대수)  
        &nbsp;&nbsp;</td>
   	</tr>
 -->  	
  	<tr> 
      <td colspan=2><font color="#FF00FF">♣ 관리비용</font>     : ((기본식평균/전체기본식평균)*(기본식비용/비용(본인))+(일반식평균/전체일반식평균)*(일반식비용/비용(본인)))*1대당평균관리비용(전체비용/전체대수)  
        &nbsp;&nbsp;</td>
   	</tr>
    <tr> 
      <td colspan=2><font color="#FF00FF">♣ 재리스 정비</font> : 기본식-> 영업효율에 반영, 일반식->대여개시 2개월이전:영업효율에 반영, 대여개시 2개월이후:일반정비비로 반영</td>
   	</tr>
   	<tr> 
      <td>&nbsp;&nbsp;&nbsp;</td>
      <td><font color=red>(</font> 
       
		정비관련 대차비용, 탁송비용, 탁송유류대도 위의 재리스 정비와 동일하게 적용 <font color=red>)</font>
		</td>	
    </tr>
   	<!--
    <tr> 
      <td colspan=2><font color="#999999"><font color="#FF00FF">♣ 휴대폰 정산방법</font> : 평균사용료(본사/지점별 1군/2군 평균)의 초과(미만)금액 10배 할증(차감)</td>
   	</tr>
   	<tr> 
      <td colspan=2><font color="#999999"><font color="#FF00FF">♣ 유류대(활동비) 정산방법</font> : 평균사용료(본사/지점별 1군/2군 평균)의 초과(미만)금액 5배 할증(차감)</td>
   	</tr>
   	
 	<tr> 
      <td colspan=2><font color="#FF00FF">♣ 차량관리대수</font> : 캠페인 기간내의 평균관리대수</td>
    </tr> 
    
    -->
    <tr> 
      <td colspan=2><font color="#FF00FF">♣ 포상금액</font>     : (개인별대당평균관리비용계/인원수 - 본인1대당평균관리비용)* 관리대수 (최소금액:150,000원)</td>
    </tr>
    <tr> 
      <td width="98">&nbsp;&nbsp;&nbsp;1. 평가기준기간</td>
      <td>: 
        <input type="text" name="cs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
		~
		<input type="text" name="ce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
	  </td>	
	</tr>
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;2. 기준금액</td>
      <td>: 
       	일반정비비 최대적용금액: <input type="text" name="amt1" size="11" value="<%= AddUtil.parseDecimal(amt1) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		원&nbsp;&nbsp;초과금액 반영률: <input type="text" name="amt1_per" size="3" value="<%= AddUtil.parseDecimal(amt1_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>%
		</td>	
    </tr>
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;</td>
      <td>: 
       
		사고수리비 최대적용금액: <input type="text" name="amt2" size="11" value="<%= AddUtil.parseDecimal(amt2) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		원&nbsp;&nbsp;초과금액 반영률: <input type="text" name="amt2_per" size="3" value="<%= AddUtil.parseDecimal(amt2_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>%
		</td>	
    </tr>
     
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;</td>
      <td>: 
       
		기타, 활동비용: 100% 반영
		</td>	
    </tr>
        <tr> 
      <td>&nbsp;&nbsp;&nbsp;</td>
      <td>: 
       
		 최대 관리비용:  7만원 반영
		</td>	
    </tr>
    
     <tr> 
      <td>&nbsp;&nbsp;&nbsp;3. 분배기준</td>
      <td>: 
        비용(정비비,사고수리비)  및 매출 발생시:&nbsp;&nbsp; 최초영업자<input type="text" name="bus_cost_per" size="3" value="<%= AddUtil.parseDecimal(bus_cost_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> %
        &nbsp;&nbsp; 관리담당자:<input type="text" name="mng_cost_per" size="3" value="<%= AddUtil.parseDecimal(mng_cost_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> %
	  </td>
	</tr>
		
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;4. 대차기준</td>
      <td>: 
        실대차일&nbsp;&nbsp; * 기준값:보유차(매월1일 산정)의 월대여료의 1일 대여료
	  </td>
	</tr>
	
	<tr> 
      <td>&nbsp;&nbsp;&nbsp;5. 캠페인대수</td>
      <td>: 
        캠페인 기간내 평균관리대수:<input type="text" name="car_cnt" readonly  size="3" value="<%= AddUtil.parseDecimal(car_cnt) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> %,
        &nbsp;&nbsp; 캠페인 기간내 매출에 따른 계산된 관리대수:<input type="text" readonly name="sale_cnt" size="3" value="<%= AddUtil.parseDecimal(sale_cnt) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> %,
	&nbsp;&nbsp; 기준대수: <input type="text" name="base_cnt" size="3" value="<%= AddUtil.parseDecimal(base_cnt) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>대 이상 
	  </td>
	</tr>
 <!--	
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;</td>  	
	    <td>: 
		1일대차적용금액기준:&nbsp;&nbsp;배기량&nbsp;&nbsp;<input type="text" name="cc1" size="9" value="<%= AddUtil.parseDecimal(cc1) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> cc 미만 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="da_amt1" size="11" value="<%= AddUtil.parseDecimal(da_amt1) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원&nbsp;&nbsp;

		&nbsp;&nbsp;
		</td>
    </tr>
    <tr>
	    <td>&nbsp;&nbsp;&nbsp;</td>  	
	    <td>: 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="cc2" size="9" value="<%= AddUtil.parseDecimal(cc2) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> ~ <input type="text" name="cc3" size="9" value="<%= AddUtil.parseDecimal(cc3) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> cc  &nbsp;&nbsp;<input type="text" name="da_amt2" size="11" value="<%= AddUtil.parseDecimal(da_amt2) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원&nbsp;&nbsp;

		&nbsp;&nbsp;
		</td>
    </tr>
    <tr>
	    <td>&nbsp;&nbsp;&nbsp;</td>  	
	    <td>: 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="cc4" size="9" value="<%= AddUtil.parseDecimal(cc4) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> cc 이상 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="da_amt3" size="11" value="<%= AddUtil.parseDecimal(da_amt3) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원&nbsp;&nbsp;
		&nbsp;&nbsp;
		</td>
    </tr>
  --> 

<% if ( auth_rw.equals("6") || auth_rw.equals("4") ) { %> 
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;5. 포상금액 적용효율</td>
      <td>:
       <input type="text" name="cam_per" size="3" value="<%= AddUtil.parseDecimal(cam_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
      % 반영.</td>
    </tr>
<% } %>      
  </table>


  <table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td width="730" colspan="2">&nbsp;&nbsp;&nbsp;♣ 계산식보기==&gt; <a href="javascript:view_sik();"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a> 
        </td>
        <td></td>
    </tr>
  </table>
<% if ( auth_rw.equals("6") || auth_rw.equals("4") ) { %>   
  <table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td align=right><a href='javascript:updateVar()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify_bs.gif"  align="absmiddle" border="0"></a></td>
    </tr>
  </table>
<% } %>  
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

