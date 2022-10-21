<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
   	
   	String save_dt = ad_db.getMaxSaveDt("stat_bus_cmp");
   	String v_year		= "";
	String v_tm		= "";
   	Vector vt = cmp_db.getCampaignList_2012_05_sc2(save_dt, "", "", "");//20120501 캠페인대상 적용   	
   	//등록일시
	if(vt.size()>0){
		for(int i=0; i<1; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			v_year 	= (String)ht.get("YEAR");
			v_tm 	= (String)ht.get("TM");
		}
	}	
	//영업캠페인변수 : campaign_var 테이블
	Hashtable ht3 = cmp_db.getCampaignVar(v_year, v_tm, "1"); //1군 변수
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
	   	
	//비용캠페인변수 : cost_campaign 테이블
//	Hashtable ht3 = ac_db.getCostCampaignVar2("2");	
//	String year 		= (String)ht3.get("YEAR");
//	String tm 			= (String)ht3.get("TM");
//	String cs_dt 		= (String)ht3.get("CS_DT");
//	String ce_dt 		= (String)ht3.get("CE_DT");
//	int v_amt1 			= AddUtil.parseInt((String)ht3.get("AMT1"));
//	int v_second_per	= AddUtil.parseInt((String)ht3.get("SECOND_PER"));
//	int v_maker_dc_a	= AddUtil.parseInt((String)ht3.get("MAKER_DC_A"));
	
	Vector vts2 = ac_db.getSaleCostCampaignDeptStatList(s_kd, t_wd, sort, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, cs_dt, ce_dt);
	int vt_size2 = vts2.size(); 
	
	Vector vts1 = ac_db.getSaleCostCampaignGoodStatList(s_kd, t_wd, sort, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, cs_dt, ce_dt);
	int vt_size1 = vts1.size(); 
	
	int car_type_cnt = 0;
	int car_type_size1 = 0;
	int car_type_size2 = 0;
	int car_type_size3 = 0;
	for(int i = 0 ; i < vt_size1 ; i++){
		Hashtable ht = (Hashtable)vts1.elementAt(i);
		if(String.valueOf(ht.get("CAR_TYPE")).equals("1")) car_type_size1++;
		if(String.valueOf(ht.get("CAR_TYPE")).equals("2")) car_type_size2++;
		if(String.valueOf(ht.get("CAR_TYPE")).equals("3")) car_type_size3++;
	}
	
   	long rent_way_2_cnt[]	= new long[5];//기본식영업대수
	long rent_way_1_cnt[]	= new long[5];//일반식영업대수
	long rent_way_t_cnt[]	= new long[5];//영업대수소계
	
   	long af_amt[]	 		= new long[5];
	long ea_amt[]	 		= new long[5];
	long bc_s_g[]	 		= new long[5];
	long fee_s_amt[]		= new long[5];
	
	long a_amt[]	 		= new long[5];
   	long s_tot[]	 		= new long[5];
	long ac_amt[]	 		= new long[5];
	long g_tot[]	 		= new long[5];
	long ave_amt[]			= new long[5];
	
   	float f_amt8[]			= new float[5];
   	float f_af_amt[]		= new float[5];
   	float f_fee_s_amt[]		= new float[5];
	
   	long amt1[]	 			= new long[5];
	long amt2[]	 			= new long[5];
	long amt3[]	 			= new long[5];
	long amt4[]	 			= new long[5];
	long amt5[]	 			= new long[5];
	long amt6[]	 			= new long[5];
	long amt7[]	 			= new long[5];
	long amt8[]	 			= new long[5];
	long amt9[]	 			= new long[5];
	long amt10[] 			= new long[5];
	long amt11[] 			= new long[5];
	long amt12[] 			= new long[5];
	long amt13[] 			= new long[5];
	long amt14[] 			= new long[5];
	long amt15[] 			= new long[5];
	long amt16[] 			= new long[5];
	long amt17[] 			= new long[5];
	long amt18[] 			= new long[5];
	long amt19[] 			= new long[5];
	long amt20[] 			= new long[5];
	long amt21[] 			= new long[5];
	long amt22[] 			= new long[5];
	long amt23[] 			= new long[5];
	long amt24[] 			= new long[5];
	long amt25[] 			= new long[5];
	long amt26[] 			= new long[5];
	long amt27[] 			= new long[5];
	long amt28[] 			= new long[5];
	long amt29[] 			= new long[5];
	long amt30[] 			= new long[5];
	long amt31[] 			= new long[5];
	long amt32[] 			= new long[5];
	long amt33[] 			= new long[5];
	long amt34[] 			= new long[5];
	long amt35[] 			= new long[5];
	long amt36[] 			= new long[5];
	long amt39[] 			= new long[5];
	long amt40[] 			= new long[5];
	long amt43[] 			= new long[5];
	long amt44[] 			= new long[5];
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
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

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">

<table border="0" cellspacing="0" cellpadding="0" width="4980">
   <tr>
   	<td colspan=2 class=line2></td>
   </tr>
   <tr id='tr_title' style='position:relative;z-index:1'>
  
	<td class='line' width='340' id='td_title' style='position:relative;'> 

	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=90>
          <tr> 
           <td class='title' colspan=6 >구분</td>
          </tr>
          <tr> 
           <td width='30' class='title' rowspan=2>연번</td>
           <td width='160' class='title' rowspan=2>구분</td>
           <!--<td width='60' class='title' rowspan=2>성명</td>-->
           <td class='title' colspan=3 >영업대수</td>
          </tr>
          <tr> 
           <td  width="50" class='title' >기본식</td>
           <td  width="50" class='title' >일반식</td>
           <td  width="50" class='title' >소계</td>
          </tr>
        
        </table></td>
	<td class='line' width='4640'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=90>
          <tr>
            <td width='110' class='title' rowspan=3>계약대여료<br>현재가치</td>		  
            <td width='110' class='title' rowspan=3>영업<br>효율</td>
            <td width='80' class='title' rowspan=3>비율</td>		 
            <td width='110' class='title' rowspan=3>정상대여료</td>
            <td width='110' class='title' rowspan=3>계약대여료</td>		
            <td width='80' class='title' rowspan=3>할인율</td>		 				
         	<td class="title" colspan=14>견적관리비+기대마진+기타수익</td>
           	<td class="title" colspan=14>비용항목</td>
            <td class="title" colspan=9>기타영업효율반영값</td>
          </tr>
          
          <tr>
         	<td width=110 class="title" rowspan=2>기본식<br>관리비</td>
            <td width=110 class="title" rowspan=2>일반식<br>관리비</td>
            <td width=110 class="title" rowspan=2>기대마진</td>
			<td width=110 class="title" rowspan=2>고객피보험<br>가입비</td>
            <td width=110 class="title" rowspan=2>재리스<br>초기영업비용</td>
            <td width=110 class="title" rowspan=2>재리스<br>중고차<br>평가이익</td>
            <td width=110 class="title" rowspan=2>카드결제<br>캐쉬백</td>
            <td width=110 class="title" rowspan=2>카드결제캐쉬백<br>견적반영분</td>
            <td width=110 class="title" rowspan=2>출고보전수당</td>
            <td width=110 class="title" rowspan=2>실적이관권장수당</td>
            <td width=110 class="title" rowspan=2>업무진행수당</td>
            <td width=110 class="title" rowspan=2>기타</td>   
            <td width=110 class="title" rowspan=2>소계</td> 
            <td width=80 class="title" rowspan=2>계약<br>대여료<br>대비</td>			
            
            <td width=110 class="title" rowspan=2>기본식<br>최소<br>관리비용</td> 
            <td width=110 class="title" rowspan=2>일반식<br>최소<br>관리비용</td>  
            <td width=110 class="title" rowspan=2>재리스차량<br>수리비<br>(참고값)</td> 
            <td width=110 class="title" rowspan=2>적용<br>재리스차량<br>수리비</td>  
            <td width=110 class="title" rowspan=2>메이커추가<br>탁송비용</td>
            <td width=110 class="title" rowspan=2>썬팅비용</td> 
            <td width=110 class="title" rowspan=2>지급용품</td>  
            <td width=110 class="title" rowspan=2>견적미반영<br>서비스품목</td> 
            <td width=110 class="title" rowspan=2>차량인도<br>탁송비용</td>  			
            <td width=110 class="title" rowspan=2>차량인도<br>유류비</td>  
            <td width=110 class="title" rowspan=2>렌트<br>긴급출동<br>보험가입비</td>  			
            <td width=110 class="title" rowspan=2>기타<br>비용</td> 
            <td class="title" colspan=2>비용소계</td>  
            
            <td width=110 class="title" rowspan=2>메이커<br>정상D/C<br>(참고값)</td>  
            <td width=110 class="title" rowspan=2>메이커<br>추가D/C<br>(반영값)</td> 
            <td width=110 class="title" rowspan=2>잔가리스크<br>감소효과</td>  
            <td width=110 class="title" rowspan=2>대차계약<br>위약금면제<br>(참고값)</td>
            <td width=110 class="title" rowspan=2>평가적용<br>위약금면제</td>  
            <td width=110 class="title" rowspan=2>계약승계<br>수수료</td>
            <td width=110 class="title" rowspan=2>해지정산금</td>
            <td width=110 class="title" rowspan=2>기타</td>  
            <td width=110 class="title" rowspan=2>소계</td>               
          </tr> 
          <tr>
            <td width=110 class="title" >실비용</td>  
            <td width=110 class="title" >평가치</td>   
          </tr>
        </table>
	</td>
  </tr>	
  
<%	if(vt_size2 > 0){%>
  <tr height=100>
	  <td class='line' width='340' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
        <%		for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] = rent_way_1_cnt[0]+rent_way_2_cnt[0];
					
					rent_way_1_cnt[1] += rent_way_1_cnt[0];
					rent_way_2_cnt[1] += rent_way_2_cnt[0];
					rent_way_t_cnt[1] += rent_way_t_cnt[0];
					
					gubun3 = "";
					gubun4 = "";
					gubun5 = "";
					gubun6 = "";
					String d_nm = "";
					if(String.valueOf(ht.get("DEPT_ID")).equals("0001")){			d_nm = "영업팀";		gubun6 = "1";
					}else if(String.valueOf(ht.get("DEPT_ID")).equals("0002")){		d_nm = "고객지원팀";		gubun6 = "2";
					}else if(String.valueOf(ht.get("DEPT_ID")).equals("0007")){		d_nm = "부산지점";	 	gubun6 = "3";
					}else if(String.valueOf(ht.get("DEPT_ID")).equals("0008")){		d_nm = "대전지점";	 	gubun6 = "4";

					}
		%>
          <tr> 
          	 <td align="center" width='30'><%= i+1%></td>
             <td align="center" colspan="2"><a href="javascript:parent.list_move('<%=gubun3%>','<%=gubun4%>','<%=gubun5%>','<%=gubun6%>');"><%=d_nm%></a></td>
             <td align="right" width='50'><%=rent_way_2_cnt[0]%>&nbsp;</td>
             <td align="right" width='50'><%=rent_way_1_cnt[0]%>&nbsp;</td>
             <td align="right" width='50'><%=rent_way_t_cnt[0]%>&nbsp;</td>
          </tr>
          <%}%>
          <tr> 
            <td class=title style='text-align:center;' colspan=3>소계</td>
            <td class=title style='text-align:right;'><%=rent_way_2_cnt[1]%>&nbsp;</td>
            <td class=title style='text-align:right;'><%=rent_way_1_cnt[1]%>&nbsp;</td>
            <td class=title style='text-align:right;'><%=rent_way_t_cnt[1]%>&nbsp;</td>
          </tr>		
        <%		car_type_cnt = 0;
				for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					if(String.valueOf(ht.get("CAR_TYPE")).equals("1")){
						rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
						rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
						rent_way_t_cnt[0] = rent_way_1_cnt[0]+rent_way_2_cnt[0];
						
						rent_way_1_cnt[2] += rent_way_1_cnt[0];
						rent_way_2_cnt[2] += rent_way_2_cnt[0];
						rent_way_t_cnt[2] += rent_way_t_cnt[0];
						
						gubun3 = "1";
						gubun4 = "";
						gubun5 = "";
						gubun6 = "";
						String d_nm = "";
						if(String.valueOf(ht.get("GOOD")).equals("11")){			d_nm = "렌트 일반식";	gubun4 = "1";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("12")){		d_nm = "렌트 기본식";	gubun4 = "1";	gubun5 = "2";
						}else if(String.valueOf(ht.get("GOOD")).equals("21")){		d_nm = "리스 일반식";	gubun4 = "2";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("22")){		d_nm = "리스 기본식";	gubun4 = "2";	gubun5 = "2";
						}
		%>
          <tr> 
          	 <td align="center" width='30'><%= i+1+vt_size2%></td>
			 <%if(car_type_cnt==0){%>
             <td align="center" width='60' rowspan='<%=car_type_size1%>'><a href="javascript:parent.list_move('<%=gubun3%>','<%//=gubun4%>','<%//=gubun5%>','<%=gubun6%>');">신차</a></td>
			 <%}%>
             <td align="center" width='100'><a href="javascript:parent.list_move('<%=gubun3%>','<%=gubun4%>','<%=gubun5%>','<%=gubun6%>');"><%=d_nm%></a></td>
             <td align="right" width='50'><%=rent_way_2_cnt[0]%>&nbsp;</td>
             <td align="right" width='50'><%=rent_way_1_cnt[0]%>&nbsp;</td>
             <td align="right" width='50'><%=rent_way_t_cnt[0]%>&nbsp;</td>
          </tr>
          <%						car_type_cnt++;}}%>		  
          <tr> 
            <td class=title style='text-align:center;' colspan=3>소계</td>
            <td class=title style='text-align:right;'><%=rent_way_2_cnt[2]%>&nbsp;</td>
            <td class=title style='text-align:right;'><%=rent_way_1_cnt[2]%>&nbsp;</td>
            <td class=title style='text-align:right;'><%=rent_way_t_cnt[2]%>&nbsp;</td>
          </tr>				    
        <%		car_type_cnt = 0;
				for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					if(String.valueOf(ht.get("CAR_TYPE")).equals("2")){
						rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
						rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
						rent_way_t_cnt[0] = rent_way_1_cnt[0]+rent_way_2_cnt[0];
						
						rent_way_1_cnt[3] += rent_way_1_cnt[0];
						rent_way_2_cnt[3] += rent_way_2_cnt[0];
						rent_way_t_cnt[3] += rent_way_t_cnt[0];
						
						gubun3 = "2";
						gubun4 = "";
						gubun5 = "";
						gubun6 = "";
						String d_nm = "";
						if(String.valueOf(ht.get("GOOD")).equals("11")){			d_nm = "렌트 일반식";	gubun4 = "1";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("12")){		d_nm = "렌트 기본식";	gubun4 = "1";	gubun5 = "2";
						}else if(String.valueOf(ht.get("GOOD")).equals("21")){		d_nm = "리스 일반식";	gubun4 = "2";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("22")){		d_nm = "리스 기본식";	gubun4 = "2";	gubun5 = "2";
						}
		%>
          <tr> 
          	 <td align="center" width='30'><%= i+1+vt_size2%></td>
			 <%if(car_type_cnt==0){%>
             <td align="center" width='60' rowspan='<%=car_type_size2%>'><a href="javascript:parent.list_move('<%=gubun3%>','<%//=gubun4%>','<%//=gubun5%>','<%=gubun6%>');">재리스</a></td>
			 <%}%>			 
             <td align="center" width='100'><a href="javascript:parent.list_move('<%=gubun3%>','<%=gubun4%>','<%=gubun5%>','<%=gubun6%>');"><%=d_nm%></a></td>
             <td align="right" width='50'><%=rent_way_2_cnt[0]%>&nbsp;</td>
             <td align="right" width='50'><%=rent_way_1_cnt[0]%>&nbsp;</td>
             <td align="right" width='50'><%=rent_way_t_cnt[0]%>&nbsp;</td>
          </tr>
          <%						car_type_cnt++;}}%>		  
          <tr> 
            <td class=title style='text-align:center;' colspan=3>소계</td>
            <td class=title style='text-align:right;'><%=rent_way_2_cnt[3]%>&nbsp;</td>
            <td class=title style='text-align:right;'><%=rent_way_1_cnt[3]%>&nbsp;</td>
            <td class=title style='text-align:right;'><%=rent_way_t_cnt[3]%>&nbsp;</td>
          </tr>		
        <%		car_type_cnt = 0;
				for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					if(String.valueOf(ht.get("CAR_TYPE")).equals("3")){
						rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
						rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
						rent_way_t_cnt[0] = rent_way_1_cnt[0]+rent_way_2_cnt[0];
						
						rent_way_1_cnt[4] += rent_way_1_cnt[0];
						rent_way_2_cnt[4] += rent_way_2_cnt[0];
						rent_way_t_cnt[4] += rent_way_t_cnt[0];
						
						gubun3 = "3";
						gubun4 = "";
						gubun5 = "";
						gubun6 = "";
						String d_nm = "";
						if(String.valueOf(ht.get("GOOD")).equals("11")){			d_nm = "렌트 일반식";	gubun4 = "1";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("12")){		d_nm = "렌트 기본식";	gubun4 = "1";	gubun5 = "2";
						}else if(String.valueOf(ht.get("GOOD")).equals("21")){		d_nm = "리스 일반식";	gubun4 = "2";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("22")){		d_nm = "리스 기본식";	gubun4 = "2";	gubun5 = "2";
						}
		%>
          <tr> 
          	 <td align="center" width='30'><%= i+1+vt_size2%></td>
			 <%if(car_type_cnt==0){%>
             <td align="center" width='60' rowspan='<%=car_type_size3%>'><a href="javascript:parent.list_move('<%=gubun3%>','<%//=gubun4%>','<%//=gubun5%>','<%=gubun6%>');">연장</a></td>
			 <%}%>			 			 
             <td align="center" width='100'><a href="javascript:parent.list_move('<%=gubun3%>','<%=gubun4%>','<%=gubun5%>','<%=gubun6%>');"><%=d_nm%></a></td>
             <td align="right" width='50'><%=rent_way_2_cnt[0]%>&nbsp;</td>
             <td align="right" width='50'><%=rent_way_1_cnt[0]%>&nbsp;</td>
             <td align="right" width='50'><%=rent_way_t_cnt[0]%>&nbsp;</td>
          </tr>
          <%						car_type_cnt++;}}%>		  
          <tr> 
            <td class=title style='text-align:center;' colspan=3>소계</td>
            <td class=title style='text-align:right;'><%=rent_way_2_cnt[4]%>&nbsp;</td>
            <td class=title style='text-align:right;'><%=rent_way_1_cnt[4]%>&nbsp;</td>
            <td class=title style='text-align:right;'><%=rent_way_t_cnt[4]%>&nbsp;</td>
          </tr>				    		  		    
        </table></td>
	<td class='line' width='4640' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
          <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] = rent_way_1_cnt[0]+rent_way_2_cnt[0];
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					amt1[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					amt2[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					amt3[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					amt4[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
					amt5[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
					amt6[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
					amt7[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
					amt8[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
					amt9[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
					amt10[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
					amt11[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT11")));
					amt12[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT12")));
					amt13[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT13")));
					amt14[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT14")));
					amt15[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT15")));
					amt16[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT16")));
					amt17[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT17")));
					amt18[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT18")));
					amt19[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT19")));
					amt20[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT20")));
					amt21[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));
					amt22[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT22")));
					amt23[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT23")));
					amt24[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT24")));
					amt25[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT25")));
					amt26[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT26")));
					amt27[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT27")));
					amt28[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT28")));
					amt29[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT29")));
					amt30[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));
					amt31[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT31")));
					amt32[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT32")));
					amt33[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT33")));
					amt34[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT34")));
					amt35[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT35")));
					amt36[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT36")));
					amt39[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT39")));
					amt40[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT40")));
					amt43[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT43")));
					amt44[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT44")));
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					af_amt[1] 		+= af_amt[0];
					bc_s_g[1] 		+= bc_s_g[0];
					fee_s_amt[1] 		+= fee_s_amt[0];
					f_af_amt[1] 		+= f_af_amt[0];
					f_fee_s_amt[1] 		+= f_fee_s_amt[0];
					f_amt8[1] 		+= f_amt8[0];
					ea_amt[1] 		+= ea_amt[0];
					
					amt1[1] 		+= amt1[0];
					amt2[1] 		+= amt2[0];
					amt3[1] 		+= amt3[0];
					amt4[1] 		+= amt4[0];
					amt5[1] 		+= amt5[0];
					amt6[1] 		+= amt6[0];
					amt7[1] 		+= amt7[0];
					amt8[1] 		+= amt8[0];
					amt9[1] 		+= amt9[0];
					amt10[1] 		+= amt10[0];
					amt11[1] 		+= amt11[0];
					amt12[1] 		+= amt12[0];
					amt13[1] 		+= amt13[0];
					amt14[1] 		+= amt14[0];
					amt15[1] 		+= amt15[0];
					amt16[1] 		+= amt16[0];
					amt17[1] 		+= amt17[0];
					amt18[1] 		+= amt18[0];
					amt19[1] 		+= amt19[0];
					amt20[1] 		+= amt20[0];
					amt21[1] 		+= amt21[0];
					amt22[1] 		+= amt22[0];
					amt23[1] 		+= amt23[0];
					amt24[1] 		+= amt24[0];
					amt25[1] 		+= amt25[0];
					amt26[1] 		+= amt26[0];
					amt27[1] 		+= amt27[0];
					amt28[1] 		+= amt28[0];
					amt29[1] 		+= amt29[0];
					amt30[1] 		+= amt30[0];
					amt31[1] 		+= amt31[0];
					amt32[1] 		+= amt32[0];
					amt33[1] 		+= amt33[0];
					amt34[1] 		+= amt34[0];
					amt35[1] 		+= amt35[0];
					amt36[1] 		+= amt36[0];
					amt39[1] 		+= amt39[0];
					amt40[1] 		+= amt40[0];
					amt43[1] 		+= amt43[0];
					amt44[1] 		+= amt44[0];
					
					//비용정산계	= a_amt+영업효율+재리스차량수리비+지급용품
    					s_tot[0] 		= a_amt[0] +  ea_amt[0] + amt12[0] + amt16[0];
					//활동비		= (견적관리비+기대마진+기타수익)소계+기본식최소관리비용+일반식최소관리비용
    					ac_amt[0]		= amt8[0]+amt9[0]+amt10[0]; 
					//비용소계		= 비용정산계+활동비+썬팅비용
				    	g_tot[0]		= s_tot[0] + ac_amt[0] + amt15[0];
					//영업대수당비용평균
				    	ave_amt[0] 		= s_tot[0] / rent_way_t_cnt[0];
			%>
          <tr> 
	  		<td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--계약대여료현재가치 -->
	  		<td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--영업효율 -->
	  		<td width="80" align="right">
			  <% if (  af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--비율 -->			
	  		<td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--정상대여료 -->
	  		<td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--계약대여료 -->						
	  		<td width="80" align="right">
			  <% if (  bc_s_g[0] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
			  <% } %>&nbsp;
			</td>  <!--할인율 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--기본식관리비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--일반식관리비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--기대마진-->
			<td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--고객피보험가입비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--재리스초기영업비용-->
            <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--재리스중고차평가이익-->
            <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- 카드결제캐쉬백-->
            <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- 카드결제캐쉬백견적반영분-->
            <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- 출고보전수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- 실적이관권장수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- 에이전트업무진행수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--기타-->
            <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--소계 -->
	  		<td width="80" align="right">
			  <% if (  f_af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--계약대여료대비 -->									            
            <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--기본식최소관리비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--일반식최소관리비용 --> 
            <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--재리스차량수리비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--적용재리스수리비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--메이커추가탁송 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--썬팅비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--지급용품 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--견적미반영서비스품목 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--차량인도탁송비용  -->			
            <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--차량인도유류비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--렌트긴급출동보험가입비->임시운행보험료-->			
            <td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--기타비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--실비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--평가치 -->
        
            <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--정상D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--추가D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--잔가리스크감소효과 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--대차계약위약금면제  -->
            <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--평가적용위약금면제 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--승계수수료 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--위약금    --> 	
            <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--기타  -->                   
            <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--소계 -->
          </tr>
          <%	}%>      
          <tr> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[1])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[1] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[1]/f_af_amt[1]*100),2)%>
              <% } %>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[1])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[1])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'>
			  <% if (  bc_s_g[1] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[1]-f_fee_s_amt[1])/(bc_s_g[1]-amt43[1]-amt44[1]) ) * 100),2)%>
			  <% } %>&nbsp;</td>		  												
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt1[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt2[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt3[1])%>&nbsp;</td>
			<td class=title style='text-align:right;'><%= Util.parseDecimal(amt34[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt4[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt5[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt6[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt40[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt35[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt36[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt39[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt7[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt8[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[1] == 0 ) { %> 0
              <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[1]/f_af_amt[1]*100),2)%>
              <% } %>&nbsp;</td>		  			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt9[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt10[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt11[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt12[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt13[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt15[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt16[1])%>&nbsp;</td>                       
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt17[1])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt14[1])%>&nbsp;</td>			
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt18[1])%>&nbsp;</td> 
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt33[1])%>&nbsp;</td> 			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt19[1])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt20[1])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt21[1])%>&nbsp;</td>             
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt22[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt23[1])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt24[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt25[1])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt26[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt27[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt28[1])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt29[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt30[1])%>&nbsp;</td>          
          </tr>	  
          <%	for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					
					if(String.valueOf(ht.get("CAR_TYPE")).equals("1")){
					
					rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] = rent_way_1_cnt[0]+rent_way_2_cnt[0];
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					amt1[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					amt2[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					amt3[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					amt4[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
					amt5[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
					amt6[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
					amt7[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
					amt8[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
					amt9[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
					amt10[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
					amt11[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT11")));
					amt12[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT12")));
					amt13[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT13")));
					amt14[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT14")));
					amt15[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT15")));
					amt16[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT16")));
					amt17[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT17")));
					amt18[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT18")));
					amt19[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT19")));
					amt20[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT20")));
					amt21[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));
					amt22[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT22")));
					amt23[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT23")));
					amt24[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT24")));
					amt25[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT25")));
					amt26[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT26")));
					amt27[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT27")));
					amt28[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT28")));
					amt29[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT29")));
					amt30[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));
					amt31[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT31")));
					amt32[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT32")));
					amt33[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT33")));
					amt34[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT34")));
					amt35[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT35")));
					amt36[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT36")));
					amt39[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT39")));
					amt40[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT40")));
					amt43[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT43")));
					amt44[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT44")));
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					af_amt[2] 		+= af_amt[0];
					bc_s_g[2] 		+= bc_s_g[0];
					fee_s_amt[2] 		+= fee_s_amt[0];
					f_af_amt[2] 		+= f_af_amt[0];
					f_fee_s_amt[2] 		+= f_fee_s_amt[0];
					f_amt8[2] 		+= f_amt8[0];
					ea_amt[2] 		+= ea_amt[0];
					
					amt1[2] 		+= amt1[0];
					amt2[2] 		+= amt2[0];
					amt3[2] 		+= amt3[0];
					amt4[2] 		+= amt4[0];
					amt5[2] 		+= amt5[0];
					amt6[2] 		+= amt6[0];
					amt7[2] 		+= amt7[0];
					amt8[2] 		+= amt8[0];
					amt9[2] 		+= amt9[0];
					amt10[2] 		+= amt10[0];
					amt11[2] 		+= amt11[0];
					amt12[2] 		+= amt12[0];
					amt13[2] 		+= amt13[0];
					amt14[2] 		+= amt14[0];
					amt15[2] 		+= amt15[0];
					amt16[2] 		+= amt16[0];
					amt17[2] 		+= amt17[0];
					amt18[2] 		+= amt18[0];
					amt19[2] 		+= amt19[0];
					amt20[2] 		+= amt20[0];
					amt21[2] 		+= amt21[0];
					amt22[2] 		+= amt22[0];
					amt23[2] 		+= amt23[0];
					amt24[2] 		+= amt24[0];
					amt25[2] 		+= amt25[0];
					amt26[2] 		+= amt26[0];
					amt27[2] 		+= amt27[0];
					amt28[2] 		+= amt28[0];
					amt29[2] 		+= amt29[0];
					amt30[2] 		+= amt30[0];
					amt31[2] 		+= amt31[0];
					amt32[2] 		+= amt32[0];
					amt33[2] 		+= amt33[0];
					amt34[2] 		+= amt34[0];
					amt35[2] 		+= amt35[0];
					amt36[2] 		+= amt36[0];
					amt39[2] 		+= amt39[0];
					amt40[2] 		+= amt40[0];
					amt43[2] 		+= amt43[0];
					amt44[2] 		+= amt44[0];
					
					//비용정산계	= a_amt+영업효율+재리스차량수리비+지급용품
    					s_tot[0] 		= a_amt[0] +  ea_amt[0] + amt12[0] + amt16[0];
					//활동비		= (견적관리비+기대마진+기타수익)소계+기본식최소관리비용+일반식최소관리비용
    					ac_amt[0]		= amt8[0]+amt9[0]+amt10[0]; 
					//비용소계		= 비용정산계+활동비+썬팅비용
				    	g_tot[0]		= s_tot[0] + ac_amt[0] + amt15[0];
					//영업대수당비용평균
				    	ave_amt[0] 		= s_tot[0] / rent_way_t_cnt[0];
			%>
          <tr> 
	  		<td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--계약대여료현재가치 -->
	  		<td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--영업효율 -->
	  		<td width="80" align="right">
			  <% if (  af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--비율 -->			
	  		<td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--정상대여료 -->
	  		<td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--계약대여료 -->						
	  		<td width="80" align="right">
			  <% if (  bc_s_g[0] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
			  <% } %>&nbsp;
			</td>  <!--할인율 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--기본식관리비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--일반식관리비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--기대마진-->
			<td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--고객피보험가입비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--재리스초기영업비용-->
            <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--재리스중고차평가이익-->
            <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- 카드결제캐쉬백-->
            <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- 카드결제캐쉬백견적반영분-->
            <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- 출고보전수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- 실적이관권장수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- 에이전트업무진행수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--기타-->
            <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--소계 -->
	  		<td width="80" align="right">
			  <% if (  f_af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--계약대여료대비 -->									            
            <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--기본식최소관리비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--일반식최소관리비용 --> 
            <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--재리스차량수리비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--적용재리스수리비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--메이커추가탁송 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--썬팅비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--지급용품 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--견적미반영서비스품목 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--차량인도탁송비용  -->			
            <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--차량인도유류비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--렌트긴급출동보험가입비->임시운행보험료-->			
            <td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--기타비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--실비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--평가치 -->
        
            <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--정상D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--추가D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--잔가리스크감소효과 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--대차계약위약금면제  -->
            <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--평가적용위약금면제 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--승계수수료 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--위약금    --> 	
            <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--기타  -->                   
            <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--소계 -->
          </tr>
          <%	}}%>  
          <tr> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[2])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[2] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[2]/f_af_amt[2]*100),2)%>
              <% } %>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[2])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[2])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'>
			  <% if (  bc_s_g[2] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[2]-f_fee_s_amt[2])/(bc_s_g[2]-amt43[2]-amt44[2]) ) * 100),2)%>
			  <% } %>&nbsp;</td>		  												
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt1[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt2[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt3[2])%>&nbsp;</td>
			<td class=title style='text-align:right;'><%= Util.parseDecimal(amt34[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt4[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt5[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt6[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt40[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt35[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt36[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt39[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt7[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt8[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[2] == 0 ) { %> 0
              <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[2]/f_af_amt[2]*100),2)%>
              <% } %>&nbsp;</td>		  			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt9[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt10[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt11[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt12[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt13[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt15[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt16[2])%>&nbsp;</td>                       
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt17[2])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt14[2])%>&nbsp;</td>			
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt18[2])%>&nbsp;</td> 
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt33[2])%>&nbsp;</td> 			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt19[2])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt20[2])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt21[2])%>&nbsp;</td>             
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt22[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt23[2])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt24[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt25[2])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt26[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt27[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt28[2])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt29[2])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt30[2])%>&nbsp;</td>          
          </tr>	    
          <%	for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					
					if(String.valueOf(ht.get("CAR_TYPE")).equals("2")){
					
					rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] = rent_way_1_cnt[0]+rent_way_2_cnt[0];
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					amt1[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					amt2[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					amt3[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					amt4[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
					amt5[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
					amt6[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
					amt7[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
					amt8[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
					amt9[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
					amt10[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
					amt11[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT11")));
					amt12[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT12")));
					amt13[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT13")));
					amt14[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT14")));
					amt15[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT15")));
					amt16[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT16")));
					amt17[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT17")));
					amt18[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT18")));
					amt19[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT19")));
					amt20[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT20")));
					amt21[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));
					amt22[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT22")));
					amt23[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT23")));
					amt24[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT24")));
					amt25[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT25")));
					amt26[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT26")));
					amt27[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT27")));
					amt28[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT28")));
					amt29[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT29")));
					amt30[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));
					amt31[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT31")));
					amt32[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT32")));
					amt33[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT33")));
					amt34[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT34")));
					amt35[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT35")));
					amt36[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT36")));
					amt39[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT39")));
					amt40[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT40")));
					amt43[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT43")));
					amt44[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT44")));
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					af_amt[3] 		+= af_amt[0];
					bc_s_g[3] 		+= bc_s_g[0];
					fee_s_amt[3] 		+= fee_s_amt[0];
					f_af_amt[3] 		+= f_af_amt[0];
					f_fee_s_amt[3] 		+= f_fee_s_amt[0];
					f_amt8[3] 		+= f_amt8[0];
					ea_amt[3] 		+= ea_amt[0];
					
					amt1[3] 		+= amt1[0];
					amt2[3] 		+= amt2[0];
					amt3[3] 		+= amt3[0];
					amt4[3] 		+= amt4[0];
					amt5[3] 		+= amt5[0];
					amt6[3] 		+= amt6[0];
					amt7[3] 		+= amt7[0];
					amt8[3] 		+= amt8[0];
					amt9[3] 		+= amt9[0];
					amt10[3] 		+= amt10[0];
					amt11[3] 		+= amt11[0];
					amt12[3] 		+= amt12[0];
					amt13[3] 		+= amt13[0];
					amt14[3] 		+= amt14[0];
					amt15[3] 		+= amt15[0];
					amt16[3] 		+= amt16[0];
					amt17[3] 		+= amt17[0];
					amt18[3] 		+= amt18[0];
					amt19[3] 		+= amt19[0];
					amt20[3] 		+= amt20[0];
					amt21[3] 		+= amt21[0];
					amt22[3] 		+= amt22[0];
					amt23[3] 		+= amt23[0];
					amt24[3] 		+= amt24[0];
					amt25[3] 		+= amt25[0];
					amt26[3] 		+= amt26[0];
					amt27[3] 		+= amt27[0];
					amt28[3] 		+= amt28[0];
					amt29[3] 		+= amt29[0];
					amt30[3] 		+= amt30[0];
					amt31[3] 		+= amt31[0];
					amt32[3] 		+= amt32[0];
					amt33[3] 		+= amt33[0];
					amt34[3] 		+= amt34[0];
					amt35[3] 		+= amt35[0];
					amt36[3] 		+= amt36[0];
					amt39[3] 		+= amt39[0];
					amt40[3] 		+= amt40[0];
					amt43[3] 		+= amt43[0];
					amt44[3] 		+= amt44[0];
					
					//비용정산계		= a_amt+영업효율+재리스차량수리비+지급용품
    					s_tot[0] 		= a_amt[0] +  ea_amt[0] + amt12[0] + amt16[0];
					//활동비		= (견적관리비+기대마진+기타수익)소계+기본식최소관리비용+일반식최소관리비용
    					ac_amt[0]		= amt8[0]+amt9[0]+amt10[0]; 
					//비용소계		= 비용정산계+활동비+썬팅비용
				    	g_tot[0]		= s_tot[0] + ac_amt[0] + amt15[0];
					//영업대수당비용평균
				    	ave_amt[0] 		= s_tot[0] / rent_way_t_cnt[0];
			%>
          <tr> 
	  		<td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--계약대여료현재가치 -->
	  		<td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--영업효율 -->
	  		<td width="80" align="right">
			  <% if (  af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--비율 -->			
	  		<td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--정상대여료 -->
	  		<td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--계약대여료 -->						
	  		<td width="80" align="right">
			  <% if (  bc_s_g[0] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
			  <% } %>&nbsp;
			</td>  <!--할인율 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--기본식관리비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--일반식관리비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--기대마진-->
			<td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--고객피보험가입비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--재리스초기영업비용-->
            <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--재리스중고차평가이익-->
            <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- 카드결제캐쉬백-->
            <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- 카드결제캐쉬백견적반영분-->
            <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- 출고보전수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- 실적이관권장수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- 에이전트업무진행수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--기타-->
            <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--소계 -->
	  		<td width="80" align="right">
			  <% if (  f_af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--계약대여료대비 -->									            
            <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--기본식최소관리비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--일반식최소관리비용 --> 
            <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--재리스차량수리비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--적용재리스수리비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--메이커추가탁송 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--썬팅비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--지급용품 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--견적미반영서비스품목 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--차량인도탁송비용  -->			
            <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--차량인도유류비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--렌트긴급출동보험가입비->임시운행보험료-->			
            <td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--기타비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--실비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--평가치 -->
        
            <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--정상D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--추가D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--잔가리스크감소효과 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--대차계약위약금면제  -->
            <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--평가적용위약금면제 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--승계수수료 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--위약금    --> 	
            <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--기타  -->                   
            <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--소계 -->
          </tr>
          <%	}}%>  
          <tr> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[3])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[3] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[3]/f_af_amt[3]*100),2)%>
              <% } %>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[3])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[3])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'>
			  <% if (  bc_s_g[3] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[3]-f_fee_s_amt[3])/(bc_s_g[3]-amt43[3]-amt44[3]) ) * 100),2)%>
			  <% } %>&nbsp;</td>		  												
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt1[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt2[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt3[3])%>&nbsp;</td>
			<td class=title style='text-align:right;'><%= Util.parseDecimal(amt34[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt4[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt5[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt6[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt40[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt35[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt36[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt39[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt7[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt8[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[3] == 0 ) { %> 0
              <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[3]/f_af_amt[3]*100),2)%>
              <% } %>&nbsp;</td>		  			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt9[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt10[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt11[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt12[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt13[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt15[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt16[3])%>&nbsp;</td>                       
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt17[3])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt14[3])%>&nbsp;</td>			
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt18[3])%>&nbsp;</td> 
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt33[3])%>&nbsp;</td> 			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt19[3])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt20[3])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt21[3])%>&nbsp;</td>             
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt22[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt23[3])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt24[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt25[3])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt26[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt27[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt28[3])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt29[3])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt30[3])%>&nbsp;</td>          
          </tr>	  
          <%	for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					
					if(String.valueOf(ht.get("CAR_TYPE")).equals("3")){
					
					rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] = rent_way_1_cnt[0]+rent_way_2_cnt[0];
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					amt1[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					amt2[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					amt3[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					amt4[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
					amt5[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
					amt6[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
					amt7[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
					amt8[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
					amt9[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
					amt10[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
					amt11[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT11")));
					amt12[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT12")));
					amt13[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT13")));
					amt14[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT14")));
					amt15[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT15")));
					amt16[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT16")));
					amt17[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT17")));
					amt18[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT18")));
					amt19[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT19")));
					amt20[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT20")));
					amt21[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));
					amt22[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT22")));
					amt23[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT23")));
					amt24[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT24")));
					amt25[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT25")));
					amt26[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT26")));
					amt27[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT27")));
					amt28[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT28")));
					amt29[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT29")));
					amt30[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));
					amt31[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT31")));
					amt32[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT32")));
					amt33[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT33")));
					amt34[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT34")));
					amt35[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT35")));
					amt36[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT36")));
					amt39[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT39")));
					amt40[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT40")));
					amt43[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT43")));
					amt44[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT44")));
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					af_amt[4] 		+= af_amt[0];
					bc_s_g[4] 		+= bc_s_g[0];
					fee_s_amt[4] 		+= fee_s_amt[0];
					f_af_amt[4] 		+= f_af_amt[0];
					f_fee_s_amt[4] 		+= f_fee_s_amt[0];
					f_amt8[4] 		+= f_amt8[0];
					ea_amt[4] 		+= ea_amt[0];
					
					amt1[4] 		+= amt1[0];
					amt2[4] 		+= amt2[0];
					amt3[4] 		+= amt3[0];
					amt4[4] 		+= amt4[0];
					amt5[4] 		+= amt5[0];
					amt6[4] 		+= amt6[0];
					amt7[4] 		+= amt7[0];
					amt8[4] 		+= amt8[0];
					amt9[4] 		+= amt9[0];
					amt10[4] 		+= amt10[0];
					amt11[4] 		+= amt11[0];
					amt12[4] 		+= amt12[0];
					amt13[4] 		+= amt13[0];
					amt14[4] 		+= amt14[0];
					amt15[4] 		+= amt15[0];
					amt16[4] 		+= amt16[0];
					amt17[4] 		+= amt17[0];
					amt18[4] 		+= amt18[0];
					amt19[4] 		+= amt19[0];
					amt20[4] 		+= amt20[0];
					amt21[4] 		+= amt21[0];
					amt22[4] 		+= amt22[0];
					amt23[4] 		+= amt23[0];
					amt24[4] 		+= amt24[0];
					amt25[4] 		+= amt25[0];
					amt26[4] 		+= amt26[0];
					amt27[4] 		+= amt27[0];
					amt28[4] 		+= amt28[0];
					amt29[4] 		+= amt29[0];
					amt30[4] 		+= amt30[0];
					amt31[4] 		+= amt31[0];
					amt32[4] 		+= amt32[0];
					amt33[4] 		+= amt33[0];
					amt34[4] 		+= amt34[0];
					amt35[4] 		+= amt35[0];
					amt36[4] 		+= amt36[0];
					amt39[4] 		+= amt39[0];
					amt40[4] 		+= amt40[0];
					amt43[4] 		+= amt43[0];
					amt44[4] 		+= amt44[0];
					
					//비용정산계	= a_amt+영업효율+재리스차량수리비+지급용품
    					s_tot[0] 		= a_amt[0] +  ea_amt[0] + amt12[0] + amt16[0];
					//활동비		= (견적관리비+기대마진+기타수익)소계+기본식최소관리비용+일반식최소관리비용
    					ac_amt[0]		= amt8[0]+amt9[0]+amt10[0]; 
					//비용소계		= 비용정산계+활동비+썬팅비용
				    	g_tot[0]		= s_tot[0] + ac_amt[0] + amt15[0];
					//영업대수당비용평균
				    	ave_amt[0] 		= s_tot[0] / rent_way_t_cnt[0];
			%>
          <tr> 
	  		<td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--계약대여료현재가치 -->
	  		<td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--영업효율 -->
	  		<td width="80" align="right">
			  <% if (  af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--비율 -->			
	  		<td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--정상대여료 -->
	  		<td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--계약대여료 -->						
	  		<td width="80" align="right">
			  <% if (  bc_s_g[0] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
			  <% } %>&nbsp;
			</td>  <!--할인율 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--기본식관리비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--일반식관리비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--기대마진-->
			<td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--고객피보험가입비-->
            <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--재리스초기영업비용-->
            <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--재리스중고차평가이익-->
            <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- 카드결제캐쉬백-->
            <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- 카드결제캐쉬백견적반영분-->
            <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- 출고보전수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- 실적이관권장수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- 에이전트업무진행수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--기타-->
            <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--소계 -->
	  		<td width="80" align="right">
			  <% if (  f_af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--계약대여료대비 -->									            
            <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--기본식최소관리비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--일반식최소관리비용 --> 
            <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--재리스차량수리비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--적용재리스수리비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--메이커추가탁송 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--썬팅비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--지급용품 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--견적미반영서비스품목 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--차량인도탁송비용  -->			
            <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--차량인도유류비 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--렌트긴급출동보험가입비->임시운행보험료-->			
            <td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--기타비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--실비용 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--평가치 -->
        
            <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--정상D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--추가D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--잔가리스크감소효과 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--대차계약위약금면제  -->
            <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--평가적용위약금면제 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--승계수수료 -->
            <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--위약금    --> 	
            <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--기타  -->                   
            <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--소계 -->
          </tr>
          <%	}}%>  
          <tr> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[4])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[4] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[4]/f_af_amt[4]*100),2)%>
              <% } %>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[4])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[4])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'>
			  <% if (  bc_s_g[4] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[4]-f_fee_s_amt[4])/(bc_s_g[4]-amt43[4]-amt44[4]) ) * 100),2)%>
			  <% } %>&nbsp;</td>		  												
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt1[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt2[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt3[4])%>&nbsp;</td>
			<td class=title style='text-align:right;'><%= Util.parseDecimal(amt34[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt4[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt5[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt6[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt40[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt35[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt36[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt39[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt7[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt8[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[4] == 0 ) { %> 0
              <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[4]/f_af_amt[4]*100),2)%>
              <% } %>&nbsp;</td>		  			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt9[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt10[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt11[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt12[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt13[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt15[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt16[4])%>&nbsp;</td>                       
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt17[4])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt14[4])%>&nbsp;</td>			
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt18[4])%>&nbsp;</td> 
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt33[4])%>&nbsp;</td> 			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt19[4])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt20[4])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt21[4])%>&nbsp;</td>             
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt22[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt23[4])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt24[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt25[4])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt26[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt27[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt28[4])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt29[4])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt30[4])%>&nbsp;</td>          
          </tr>	  		  		    				  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='340' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='4640'>
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
