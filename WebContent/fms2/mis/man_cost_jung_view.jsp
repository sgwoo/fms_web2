<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

    String s_user =  request.getParameter("user_id")==null?"":request.getParameter("user_id");	
   
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

	int amt1 			= AddUtil.parseInt((String)ht3.get("AMT1"));
	int amt2 			= AddUtil.parseInt((String)ht3.get("AMT2"));
	int amt3 			= AddUtil.parseInt((String)ht3.get("AMT3"));
	int rent_way_1_per 		= AddUtil.parseInt((String)ht3.get("RENT_WAY_1_PER"));
	int rent_way_2_per 	= AddUtil.parseInt((String)ht3.get("RENT_WAY_2_PER"));
	int max_day			= AddUtil.parseInt((String)ht3.get("MAX_DAY"));
	
	int amt1_per 		= AddUtil.parseInt((String)ht3.get("AMT1_PER")); //한도
	int amt2_per 		= AddUtil.parseInt((String)ht3.get("AMT2_PER")); //한도
	int amt3_per 		= AddUtil.parseInt((String)ht3.get("AMT3_PER")); //한도
	
	int bus_cost_per 		= AddUtil.parseInt((String)ht3.get("BUS_COST_PER"));
	int mng_cost_per 		= AddUtil.parseInt((String)ht3.get("MNG_COST_PER"));
	
	int base_cnt 		= AddUtil.parseInt((String)ht3.get("BASE_CNT"));	
			
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_bus_cost_cmp");
			
	Vector vts2 = ac_db.getCostManCampaignNew(save_dt, "1", base_cnt, "", "");
	int vt_size2 = vts2.size(); 
	
	long ave_all_i_amt = 0;
    long ave_all_b_amt = 0;
    long one_per_cost = 0;   
    
    long p_ave_amt = 0;  

    String dept_nm = "";
 			
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
	fm.action = "/fms2/mis/cost_var_iu.jsp";
	fm.target = 'i_no';
	fm.submit();
}

	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}


//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 
<input type="hidden" name="gubun" value="1"> 
<input type="hidden" name="from_page" value="/fms2/mis/man_cost_jung.jsp"> 
 

<table border="0" cellspacing="0" cellpadding="0" width="2500">
   <tr>
   	<td colspan=2 class=line2></td>
   </tr>
   <tr id='tr_title' style='position:relative;z-index:1'>
  
	<td class='line' width='24%' id='td_title' style='position:relative;'> 

	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=71>
          <tr> 
           <td class='title' colspan=12 >구분</td>
          </tr>
          <tr> 
           <td width='18%' class='title' rowspan=2 style='height:47'>부서</td>
           <td width='6%' class='title' rowspan=2>연번</td>
           <td width='13%' class='title' rowspan=2>성명</td>
           <td width='21%' class='title' colspan=3 >캠페인대수</td>
           <td width='21%' class='title' colspan=3 >관리대수</td>
           <td width='21%' class='title' colspan=3 >매출대수</td>
          </tr>
          <tr> 
           <td  width="7%" class='title' >기본식</td>
           <td  width="7%" class='title' >일반식</td>
           <td  width="7%" class='title' >소계</td>
           <td  width="7%" class='title' >기본식</td>
           <td  width="7%" class='title' >일반식</td>
           <td  width="7%" class='title' >소계</td>
           <td  width="7%" class='title' >기본식</td>
           <td  width="7%" class='title' >일반식</td>
           <td  width="7%" class='title' >소계</td>
          </tr>
        
        </table></td>
	<td class='line' width='76%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=71>
         <tr>
         	<td width='15%' class="title" colspan=3>매출</td>         	
         	<td width='4%' class='title' rowspan=3 style='height:70'>1대당<br>월평균<br>관리비용</td>
           	<td width='4%' class='title' rowspan=3>1대당<br>기본식<br>월평균<br>관리비용</td>
         	<td width='4%' class='title' rowspan=3>1대당<br>일반식<br>월평균<br>관리비용</td>
         	<td width='4%' class='title' rowspan=3>기본식<br>관리비용</td>
         	<td width='4%' class='title' rowspan=3>일반식<br>관리비용</td>
            		
         	<td width='12%' class="title" colspan=3>차량정비비</td>
         	<td width='4%' class='title' rowspan=3 >대차비용</td>
           <td width='4%' class='title' rowspan=3 >휴/대차료<br>(수입)</td>
         	<td width=16% class="title" colspan=5>기타</td>
           <td class="title" rowspan=3 width="4%">차량관리비용계(정비비<br>+대차-휴/대차<br>+기타)</td>
           <td width="4%"  class="title" rowspan=3>교통비외</td>
           <td width="4%"  class="title" rowspan=3>예비차</td>  
            <td width='7%' class='title' rowspan=3>비용정산계<br>(차량관리비용<br>+활동비)</td>
           
      	
          </tr>
          <tr>
          	<td width=5% class="title" rowspan=2>기본식</td>
            <td width=5% class="title" rowspan=2>일반식</td>
            <td width=5% class="title" rowspan=2>소계</td>
           	<td width=4% class="title" rowspan=2>정비비</td>
            <td width=4% class="title" rowspan=2>사고수리비<br>(수리비-고객부담금)</td>
            <td width=4% class="title" rowspan=2>소계</td>
            <td width=4% class="title" rowspan=2>탁송료</td>         
            <td width=4% class="title" rowspan=2>긴급출동</td>
            <td width=4% class="title" rowspan=2>검사비</td>
            <td width=4% class="title" rowspan=2>유류대</td>
            <td width=4% class="title" rowspan=2>소계</td>  
          </tr>
 		        
        </table>
	</td>
  </tr>	
<%	if(vt_size2 > 0){%>
  <tr height=100>
	  <td class='line' width='24%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
        <%	
        	long i_cnt[] = new long[1];
       		long b_cnt[] = new long[1];
       		       		
        	long m_i_cnt[] = new long[1];
       		long m_b_cnt[] = new long[1];
       		       	
        	long s_i_cnt[] = new long[1];
       		long s_b_cnt[] = new long[1];
       	            	
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
        	long t_amt24[] = new long[1]; //as(일반식)
        	long t_amt25[] = new long[1]; //as 수리비계
       		long t_amt26[] = new long[1]; //긴급출동
       		
       		long t_amt27[] = new long[1]; //기본식비용
       		long t_amt28[] = new long[1]; //일반식비용
       		
      		long t_amt29[] = new long[1]; //평균유류비용
      		long t_amt30[] = new long[1]; //실사용유류비용    
      		
      		long t_amt31[] = new long[1]; //평균통신비용
      		long t_amt32[] = new long[1]; //실사용통신비용     
      		
      		long t_amt33[] = new long[1]; //업무대여요금(공통)      
      		long t_amt34[] = new long[1]; //자동차검사비(공통)    
      		
      		long t_amt35[] = new long[1]; //보유차적용  
      		
      		long t_s1_ave_amt[] =  new long[1]; //일반식 매출      
      		long t_s2_ave_amt[] =  new long[1]; //기본식 매출          		
    
 		    long bb_cnt = 0;
 		    long ii_cnt = 0 ;
 		    long cc_amt = 0 ;
 		     		       	
        	long t_i_amt= 0;   //일반식 비용
        	long t_b_amt= 0;   //기본식 비용
 		       
        %>
        <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
				
				
					ii_cnt = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));  //캠페인대수(일반식)
					bb_cnt = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));  //캠페인대수(기본식)
					
					//명칭
					dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("USER_ID")));
					
					for(int j=0; j<1; j++){
												
						i_cnt[j] += ii_cnt;
						b_cnt[j] += bb_cnt;
						
						m_i_cnt[j] += AddUtil.parseLong(String.valueOf(ht.get("M_WAY_1_CNT")));		//관리대수(일반식)	
						m_b_cnt[j] += AddUtil.parseLong(String.valueOf(ht.get("M_WAY_2_CNT")));	    //관리대수(기본식)	
						s_i_cnt[j] += AddUtil.parseLong(String.valueOf(ht.get("SALE_WAY_1_CNT")));	    //매출대수(일반식)	
						s_b_cnt[j] += AddUtil.parseLong(String.valueOf(ht.get("SALE_WAY_2_CNT")));	    //매출대수(기본식)	
					
					}	
					
		%>
          <tr> 
             <td align="center" width='18%'><%=dept_nm%>&nbsp;</td>
          	 <td align="center" width='6%'><%= i+1%></td>
             <td align="center" width='13%'><%=ht.get("USER_NM")%>&nbsp;        
        	 <!--  <a href="javascript:MM_openBrWindow('man_cost_jung_detail_list.jsp?mng_id=<%= ht.get("USER_ID") %>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&mng_nm=<%=ht.get("USER_NM")%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>','popwin_list','scrollbars=yes,status=no,resizable=yes,width=950,height=560,top=30,left=30')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a> -->
        	<!--   <a href="javascript:MM_openBrWindow('man_cost_jung_detail_list2.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>','popwin_list2','scrollbars=yes,status=no,resizable=yes,width=1100,height=760,top=30,left=30')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a> 
                     -->
             </td>
             <td align="right" width='7%'><%=bb_cnt%></td>
             <td align="right" width='7%'><%=ii_cnt%></td>
             <td align="right" width='7%'><%=ii_cnt + bb_cnt%></td>
             <td align="right" width='7%'><%=Util.parseDecimal(String.valueOf(ht.get("M_WAY_2_CNT")))%></td>
             <td align="right" width='7%'><%=Util.parseDecimal(String.valueOf(ht.get("M_WAY_1_CNT")))%></td>
             <td align="right" width='7%'><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("M_WAY_1_CNT"))) + AddUtil.parseLong(String.valueOf(ht.get("M_WAY_2_CNT"))))%></td>
             <td align="right" width='7%'><%=Util.parseDecimal(String.valueOf(ht.get("SALE_WAY_2_CNT")))%></td>
             <td align="right" width='7%'><%=Util.parseDecimal(String.valueOf(ht.get("SALE_WAY_1_CNT")))%></td>
             <td align="right" width='7%'><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("SALE_WAY_1_CNT"))) + AddUtil.parseLong(String.valueOf(ht.get("SALE_WAY_2_CNT"))))%></td>
          </tr>
          <%}%>
          <tr> 
            <td class=title style='text-align:center;' colspan=3>합계</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(b_cnt[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(i_cnt[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(b_cnt[0] + i_cnt[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(m_b_cnt[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(m_i_cnt[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(m_i_cnt[0] + m_b_cnt[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(s_b_cnt[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(s_i_cnt[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(s_i_cnt[0] + s_b_cnt[0])%></td>
          </tr>		  
        </table></td>
        
	<td class='line' width='76%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					for(int j=0; j<1; j++){	
						
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1")));	 //정비비(일반식)	
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT2")));	 //as(기본식)
						t_amt3[j]  += AddUtil.parseLong(String.valueOf(ht.get("AMT3"))); //사고수리비(일반식)
						t_amt4[j]  += AddUtil.parseLong(String.valueOf(ht.get("AMT4"))); //탁송료(일반식)
						t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT5")));  //카드유류대(공통)
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT6")));  //활동비유류대(공통)
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT7")));  //통신비(공통)
					         t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT8")));  //교통비(공통)
					         t_amt9[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT9")));  //대차비용계(일반식+기본식)
						t_amt10[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT10"))); //정비비(일반식정비비+기본식정비비)
						t_amt11[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT11"))); //휴/대차료(일반식)
						t_amt12[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT12"))); //정비비(기본식)
						t_amt13[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT13")));  //사고수리비(기본식)
						t_amt14[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT14")));  //사고수리비계(일반식+기본식)
						t_amt15[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT15")));  //탁송유류비(일반식)
						t_amt16[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT16")));  //탁송유류비(기본식)
						t_amt17[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT17")));  //유류비계(카드유류대+탁송유류대(일반+기본)) 
						t_amt18[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT18")));  //탁송료(기본식)
						t_amt19[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT19")));   //탁송료계(일반식+기본식)
						t_amt20[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT20")));   //휴대차료(기본식)
						t_amt21[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT21")));   //대차비용(일반식)
						t_amt22[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT22")));   //대차비용(기본식)
						t_amt23[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT23")));   //휴대차료계(일반식+기본식)
						t_amt24[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT24")));   //as(일반식)
						t_amt25[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT25")));   //as계(일반식+기본식)
						t_amt26[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT26")));   //긴급출동(공통)
						t_amt33[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT27")));   //업무대여여금(공통)
						t_amt34[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT28")));   //자동차검사비(공통)
						
						t_amt27[j] += AddUtil.parseLong(String.valueOf(ht.get("WAY2_AMT")));   //기본식
						t_amt28[j] += AddUtil.parseLong(String.valueOf(ht.get("WAY1_AMT")));   //일반식
						
						t_amt29[j] += AddUtil.parseLong(String.valueOf(ht.get("OIL_AVE_AMT")));   //평균유류비용
						t_amt30[j] += AddUtil.parseLong(String.valueOf(ht.get("R_OIL_AMT")));   //실사용 유류비용
						
						t_amt31[j] += AddUtil.parseLong(String.valueOf(ht.get("HP_AVE_AMT")));   //평균통신비용
						t_amt32[j] += AddUtil.parseLong(String.valueOf(ht.get("R_HP_AMT")));   //실사용 통신비용
						
						t_amt35[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT33")));   //보유차적용
						
						t_s1_ave_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("S1_AVE_AMT")));   //일반식 매출
						t_s2_ave_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("S2_AVE_AMT")));   //기본식 매출
			
					}
										
			%>
          <tr> 
<%          
    long s_tot = 0;
    long g_tot = 0;
    long ccnt  = 0;
 
    long ave_amt1 = 0;
    long ave_amt2 = 0;
               
    long ac_amt = 0;
    long a_amt = 0;
    long ea_amt = 0;  
 	 
   long ave_amt3 = 0;  //일반식
    long ave_amt4 = 0; //기본식
  
     
    a_amt =  AddUtil.parseLong(String.valueOf(ht.get("AMT10"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT14")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT25")));  //차량정비비계
    ea_amt = AddUtil.parseLong(String.valueOf(ht.get("AMT19"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT17")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT5")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT26")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT28"))); //기타소계
    s_tot =    a_amt +  ea_amt + AddUtil.parseLong(String.valueOf(ht.get("AMT9"))) - AddUtil.parseLong(String.valueOf(ht.get("AMT23"))) ; //차량관리비용
    ac_amt =    AddUtil.parseLong(String.valueOf(ht.get("AMT8"))); //활동비
          
    g_tot  = s_tot + ac_amt+ AddUtil.parseLong(String.valueOf(ht.get("AMT33")))  ; //비용정산계
    ccnt =  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")))+ AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT"))) ;      
    
    ave_amt2 =  AddUtil.parseLong(String.valueOf(ht.get("R_ONE_PER_COST")))  ;
    ave_amt3 =  AddUtil.parseLong(String.valueOf(ht.get("AVE_I_AMT")))   ; //일반식
    ave_amt4 =  AddUtil.parseLong(String.valueOf(ht.get("AVE_B_AMT")))   ;  //기본식
    
    one_per_cost =  AddUtil.parseLong(String.valueOf(ht.get("ONE_PER_COST"))) ;  //평균비용
    ave_all_i_amt =  AddUtil.parseLong(String.valueOf(ht.get("AVE_ALL_I_AMT")))   ;  //일반식평균
    ave_all_b_amt =  AddUtil.parseLong(String.valueOf(ht.get("AVE_ALL_B_AMT")))   ;  //기본식평균
    
    p_ave_amt =  AddUtil.parseLong(String.valueOf(ht.get("P_AVE_AMT")))   ;  //1대당 평균관리비용
  
    
%>   
	<td width="5%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("S2_AVE_AMT")))%></td>  <!--기본식 매출-->
	<td width="5%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("S1_AVE_AMT")))%></td>  <!-- 일반식 매출-->  
	<td width="5%" align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("S2_AVE_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("S1_AVE_AMT"))))%></td>  <!--기본식 + 일반식 매출 -->
	<td width="4%" align="right"><%=Util.parseDecimal(ave_amt2)%></td>  <!-- 평균관리비용 -->  
	<td width="4%" align="right"><%=Util.parseDecimal(ave_amt4)%></td>  <!--월평균 기본식 관리비용-->
	<td width="4%" align="right"><%=Util.parseDecimal(ave_amt3)%></td>  <!-- 월평균 일반식 관리비용-->  
	<td width="4%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("WAY2_AMT")))%> </td>  <!--기본식 관리비용-->
	<td width="4%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("WAY1_AMT")))%> </td>  <!-- 일반식 관리비용-->  
			
            <td width="4%" align="right"><a href="javascript:MM_openBrWindow('man_cost_jung_detail_list3.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>&gg=01','popwin_list3','scrollbars=yes,status=no,resizable=yes,width=950,height=760,top=30,left=30')"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT10"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT25")))  )%></a></td>  <!--정비비 -->
       	    <td width="4%" align="right"><a href="javascript:MM_openBrWindow('man_cost_jung_detail_list3.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>&gg=04','popwin_list3','scrollbars=yes,status=no,resizable=yes,width=950,height=760,top=30,left=30')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT14")))%></a></td>  <!--사고수리비 -->
            <td width="4%" align="right"><%=Util.parseDecimal(a_amt)%></td> 
            
            <td width="4%" align="right"><a href="javascript:MM_openBrWindow('man_cost_jung_detail_list3.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>&gg=05','popwin_list3','scrollbars=yes,status=no,resizable=yes,width=950,height=760,top=30,left=30')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT9")))%></a></td> <!-- 대차비용 -->
            <td width="4%" align="right"><a href="javascript:MM_openBrWindow('man_cost_jung_detail_list3.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>&gg=06','popwin_list3','scrollbars=yes,status=no,resizable=yes,width=950,height=760,top=30,left=30')"><%=Util.parseDecimal(-AddUtil.parseLong(String.valueOf(ht.get("AMT23"))) )%></a></td> <!-- 휴/대차료 입금 -->
            
            <td width="4%" align="right"><a href="javascript:MM_openBrWindow('man_cost_jung_detail_list3.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>&gg=07','popwin_list3','scrollbars=yes,status=no,resizable=yes,width=950,height=760,top=30,left=30')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT19")))%></a></td> <!--탁송료 --> 
            <td width="4%" align="right"><a href="javascript:MM_openBrWindow('man_cost_jung_detail_list3.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>&gg=10','popwin_list3','scrollbars=yes,status=no,resizable=yes,width=950,height=760,top=30,left=30')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT26")))%></a></td> <!-- 긴급출동-->
            <td width="4%" align="right"><a href="javascript:MM_openBrWindow('man_cost_jung_detail_list3.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>&gg=03','popwin_list3','scrollbars=yes,status=no,resizable=yes,width=950,height=760,top=30,left=30')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT28")))%></a> </td> <!-- 검사비 -->    
            <td width="4%" align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT17"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT5")))  )%></td> <!--유류대 -->    
            <td width="4%" align="right"><%=Util.parseDecimal(ea_amt)%></td>
            
            <td width="4%" align="right"><%=Util.parseDecimal(s_tot)%></td>           
             
            <td width="4%" align="right"><!--<a href="javascript:MM_openBrWindow('man_cost_jung_detail_list3.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>&gg=13','popwin_list3','scrollbars=yes,status=no,resizable=yes,width=950,height=760,top=30,left=30')">--><%=Util.parseDecimal(String.valueOf(ht.get("AMT8")))%><!--</a>--></td>  <!-- 교통비외 -->
  
            <td width="4%" align="right"><!--<a href="javascript:MM_openBrWindow('man_cost_jung_detail_list3.jsp?mng_id=<%= ht.get("USER_ID") %>&mng_nm=<%=ht.get("USER_NM")%>&save_dt=<%=save_dt%>&c_e_dt=<%=ce_dt%>&bb_cnt=<%=bb_cnt%>&ii_cnt=<%=ii_cnt%>&bus_cost_per=<%=bus_cost_per%>&mng_cost_per=<%=mng_cost_per%>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>&amt2_per=<%=amt2_per%>&amt3_per=<%=amt3_per%>&gg=15','popwin_list3','scrollbars=yes,status=no,resizable=yes,width=950,height=760,top=30,left=30')">--><%=Util.parseDecimal(String.valueOf(ht.get("AMT33")))%><!--</a>--></td>  <!--예비차관련 적용 -->
                
            <td width="7%" align="right"><%=Util.parseDecimal(g_tot)%></td>
          </tr>
          <%}%>
    
          <tr> 
         	<td class=title style='text-align:right;'><%= Util.parseDecimal(t_s2_ave_amt[0])%></td>
      		<td class=title style='text-align:right;'><%= Util.parseDecimal(t_s1_ave_amt[0])%></td>                
      		<td class=title style='text-align:right;'><%= Util.parseDecimal(t_s1_ave_amt[0]+t_s2_ave_amt[0])%></td> 
          
          	<td class=title style='text-align:right;'><%= Util.parseDecimal( one_per_cost )  %></td>
      		<td class=title style='text-align:right;'><%= Util.parseDecimal( ave_all_b_amt ) %></td>                
      		<td class=title style='text-align:right;'><%= Util.parseDecimal( ave_all_i_amt ) %></td>
     	    <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt27[0])%></td>
     	    <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt28[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt10[0]+t_amt25[0]+t_amt34[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt14[0])%></td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt10[0]+t_amt14[0]+t_amt25[0])%></td>
            
        	  <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt9[0])%></td>  <!-- 대차비용 -->
           <td class=title style='text-align:right;'><%= Util.parseDecimal(-t_amt23[0])%></td>  <!-- 휴/대차료 -->
                   
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt19[0])%></td> <!-- 탁송료 -->      
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt26[0])%></td>  <!--긴급출동비 -->
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt34[0])%></td>  <!--검사비 -->
             <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt17[0]+t_amt5[0])%></td>  <!--유류대 -->
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt19[0]+t_amt17[0]+t_amt5[0]+t_amt26[0]+t_amt34[0])%></td>
    
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt10[0]+t_amt14[0]+t_amt25[0]+t_amt34[0]+t_amt9[0] - t_amt23[0] + t_amt19[0]+t_amt17[0]+t_amt5[0]+t_amt26[0]+t_amt34[0])%></td>     
       
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt8[0])%></td>         
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt35[0])%></td><!--예비차관련 적용-->    
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt10[0]+t_amt14[0]+t_amt9[0]-t_amt23[0]+ t_amt19[0]+t_amt17[0]+t_amt5[0]+t_amt26[0]+t_amt34[0]+t_amt7[0]+t_amt8[0]+t_amt33[0]+t_amt25[0]+t_amt35[0])%></td>
          
          </tr>	  
        </table>
	</td>
  </tr>
  <tr>
    <td>
     	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='left'>&nbsp;* 1대당 평균관리비용(전체비용/전체대수) : <%=Util.parseDecimal(p_ave_amt)%></td>
          </tr>
        </table> 	
  	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='24%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='76%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
</table>


</form>
</body>
</html>
