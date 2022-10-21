<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String cs_dt 	= request.getParameter("cs_dt")==null?"":request.getParameter("cs_dt");
	String ce_dt 	= request.getParameter("ce_dt")==null?"":request.getParameter("ce_dt");
	
	if(cs_dt.equals("")) cs_dt = ref_dt1;
	if(ce_dt.equals("")) ce_dt = ref_dt2;
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	Vector vts2 = ac_db.getSaleCostCampaign_20081208(cs_dt, ce_dt, t_wd);
	int vt_size2 = vts2.size();
	
   	long af_amt[]	 		= new long[2];
	long ea_amt[]	 		= new long[2];
	long bc_s_g[]	 		= new long[2];
	long fee_s_amt[]		= new long[2];
	long trf_amt[]			= new long[2];
	
	long a_amt[]	 		= new long[2];
   	long s_tot[]	 		= new long[2];
	long ac_amt[]	 		= new long[2];
	long g_tot[]	 		= new long[2];
	long ave_amt[]			= new long[2];
	
   	float f_amt8[]			= new float[2];
   	float f_af_amt[]		= new float[2];
   	float f_fee_s_amt[]		= new float[2];
	
   	long amt1[]	 			= new long[2];
	long amt2[]	 			= new long[2];
	long amt3[]	 			= new long[2];
	long amt4[]	 			= new long[2];
	long amt5[]	 			= new long[2];
	long amt6[]	 			= new long[2];
	long amt7[]	 			= new long[2];
	long amt8[]	 			= new long[2];
	long amt9[]	 			= new long[2];
	long amt10[] 			= new long[2];
	long amt11[] 			= new long[2];
	long amt12[] 			= new long[2];
	long amt13[] 			= new long[2];
	long amt14[] 			= new long[2];
	long amt15[] 			= new long[2];
	long amt16[] 			= new long[2];
	long amt17[] 			= new long[2];
	long amt18[] 			= new long[2];
	long amt19[] 			= new long[2];
	long amt20[] 			= new long[2];
	long amt21[] 			= new long[2];
	long amt22[] 			= new long[2];
	long amt23[] 			= new long[2];
	long amt24[] 			= new long[2];
	long amt25[] 			= new long[2];
	long amt26[] 			= new long[2];
	long amt27[] 			= new long[2];
	long amt28[] 			= new long[2];
	long amt29[] 			= new long[2];
	long amt30[] 			= new long[2];
	long amt31[] 			= new long[2];
	long amt32[] 			= new long[2];
	long amt33[] 			= new long[2];
	long amt34[] 			= new long[2];
	long amt35[] 			= new long[2];
	long amt36[] 			= new long[2];
	long amt39[] 			= new long[2];
	long amt40[] 			= new long[2];
	long amt43[] 			= new long[2];
	long amt44[] 			= new long[2];
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
<table border="0" cellspacing="0" cellpadding="0" width="5890">
  <tr> 
  	  <td align='right' colspan=2>&nbsp;&nbsp;</td>
  </tr>
  <tr id='tr_title' >  
	<td class='line' width='450' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=91>        
          <tr> 
           <td width='30' class='title' rowspan=2>연번</td>
           <td width='60' class='title' rowspan=2>최초<br>영업자</td>
		   <td width='60' class='title' rowspan=2>영업<br>대리인</td>
           <td width='100' class='title' rowspan=2>고객명</td>
           <td width='100' class='title' rowspan=2>차종</td>
           <td width='100' class='title' rowspan=2>차량<br>번호</td>
          </tr>        
        </table></td>
	<td class='line' width='5440'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=91>
         <tr>
            <td width='110' class='title' rowspan=3>계약대여료<br>현재가치</td>
            <td width='110' class='title' rowspan=3>영업<br>효율</td>
            <td width='80' class='title' rowspan=3>비율</td>		 
            <td width='80' class='title' rowspan=3>차량<br>구분</td>
            <td width='80' class='title' rowspan=3>계약<br>구분</td>
            <td width='80' class='title' rowspan=3>용도<br>구분</td>
            <td width='80' class='title' rowspan=3>관리<br>구분</td>
            <td width='80' class='title' rowspan=3>계약<br>기간</td>      
            <td width='110' class='title' rowspan=3>대여<br>개시일</td>               		 
            <td width='80' class='title' rowspan=3>적용<br>등급</td>
            <td width='110' class='title' rowspan=3>정상<br>대여료</td>   
            <td width='110' class='title' rowspan=3>계약<br>대여료</td>           
            <td width="80" class='title' rowspan=3>할인율</td>
            <td width="100" class='title' rowspan=3>자체<br>출고<br>여부</td>
            <td width="110" class='title' rowspan=3>카드<br>결제금액</td>
         	<td class="title" colspan=14>견적관리비+기대마진+기타수익</td>
         	<td class="title" colspan=14>비용항목</td>
            <td class="title" colspan=9>기타영업효율반영값</td>
                           
          </tr>
          <tr>
          	<td width=110 class="title" rowspan=2>기본식<br>관리비</td>
            <td width=110 class="title" rowspan=2>일반식<br>추가관리비</td>
            <td width=110 class="title" rowspan=2>기대마진</td>
			<td width=110 class="title" rowspan=2>고객피보험<br>가입비</td>
            <td width=110 class="title" rowspan=2>재리스<br>초기<br>영업비용</td>
            <td width=110 class="title" rowspan=2>재리스<br>중고차<br>평가이익</td>
            <td width=110 class="title" rowspan=2>카드결제<br>캐쉬백</td>
            <td width=110 class="title" rowspan=2>카드결제캐쉬백<br>견적반영분</td>
            <td width=110 class="title" rowspan=2>출고보전수당</td>
            <td width=110 class="title" rowspan=2>실적이관권장수당</td>            
            <td width=110 class="title" rowspan=2>에이전트업무진행수당</td>            
            <td width=110 class="title" rowspan=2>기타</td>   
            <td width=110 class="title" rowspan=2>합계</td> 
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
            <td class="title" colspan=2>비용합계</td>  
            
            <td width=110 class="title" rowspan=2>메이커<br>정상D/C<br>(참고값)</td>  
            <td width=110 class="title" rowspan=2>메이커<br>추가D/C<br>(반영값)</td> 
            <td width=110 class="title" rowspan=2>잔가리스크<br>감소효과</td>  
            <td width=110 class="title" rowspan=2>대차계약<br>위약금면제<br>(참고값)</td> 
            <td width=110 class="title" rowspan=2>평가적용<br>위약금면제</td>  
            <td width=110 class="title" rowspan=2>계약승계<br>수수료</td>  
            <td width=110 class="title" rowspan=2>해지정산금</td>  
            <td width=110 class="title" rowspan=2>기타</td>  						
            <td width=110 class="title" rowspan=2>합계</td>               
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
	  <td class='line' width='450' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
         <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);%>
          <tr>
           	 <td align="center" width='30'><%= i+1%></td> 
             <td align="center" width='60'><%=ht.get("USER_NM")%></td>
             <td align="center" width='60'><%=ht.get("BUS_AGNT_NM")%></td>			 
             <td align="center" width='100'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
             <td align="center" width='100'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
             <td align="center" width='100'><span title='<%=ht.get("CAR_NO")%>'><%=ht.get("CAR_NO")%></span></td>
          </tr>
          <%}%>
          <tr> 
             <td class=title style='text-align:center;' colspan=6>합계</td>
          </tr>		  
        </table></td>
	<td class='line' width='5440' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < vt_size2 ; i++){
					    Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 	= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					trf_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
					f_af_amt[0] 	= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_fee_s_amt[0] 	= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
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
					trf_amt[1] 		+= trf_amt[0];
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
             <td align="center" width='80'><%=ht.get("CAR_GU_NM")%>&nbsp;</td>
             <td align="center" width='80'><%=ht.get("RENT_ST_NM")%>&nbsp;</td>
             <td align="center" width='80'><%=ht.get("CAR_ST_NM")%>&nbsp;</td>
             <td align="center" width='80'><%=ht.get("RENT_WAY_NM")%>&nbsp;</td>
             <td align="center" width='80'><%=ht.get("CON_MON")%>&nbsp;</td>
             <td align="center" width='110'><%=ht.get("RENT_START_DT")%>&nbsp;</td>		  
	  		<td align="center" width='80'><%=ht.get("SPR_KD_NM")%>&nbsp;</td>
	  		<td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--정상대여료 -->
	  		<td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--계약대여료 -->						
	  		<td width="80" align="right">
			  <% if (  bc_s_g[0] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
			  <% } %>&nbsp;
			</td>  <!--할인율 -->
	  		<td width="100" align="center"><%=ht.get("COMMI2_NM")%>&nbsp;</td>
	  		<td width="110" align="right"><%=Util.parseDecimal(trf_amt[0])%>&nbsp;</td>  <!--카드결재금액-->
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
            <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- 실적이관권장수당-->
            <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--기타-->
            <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--합계 -->
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
            <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--합계 -->
            
          </tr>
          <%}%>
    
           <tr> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[1])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[1] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[1]/f_af_amt[1]*100),2)%>
              <% } %>&nbsp;</td>		  
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>			 			 			 			 			 			 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[1])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[1])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'>
			  <% if (  bc_s_g[1] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[1]-f_fee_s_amt[1])/(bc_s_g[1]-amt43[1]-amt44[1]) ) * 100),2)%>
			  <% } %>&nbsp;</td>		  												
            <td class=title style='text-align:right;'>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(trf_amt[1])%>&nbsp;</td>
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
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='450' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='5440'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
  <tr> 
  	  <td colspan=2>1. 영업대수 : 6개월 이상 계약 기준</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * 6개월 미만 계약건 : 총계약개월수와 영업효율 값에만 반영</td>
  </tr>
  <tr> 
  	  <td colspan=2>2. 적용 재리스차량 수리비는 실 재리스차량 수리비의 50% </td>
  </tr>
  <tr> 
  	  <td colspan=2>3. 메이커 추가탁송비용 = 실 지불 메이커 탁송료 - 견적프로그램상의 메이커 탁송료</td>
  </tr>
  <tr> 
  	  <td colspan=2>4. 메이커 추가D/C : 견적에도 반영하고 추가로 영업효율에 또 반영 </td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 소비자차가의 5%까지는 50%, 5%초과분에 대해서는 20% 반영 (공급가 기준)</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 메이커 D/C중 탁송료 추가 발행에 따른 D/C(추가탁송료D/C)는 정상 D/C금액에 포함 </td>
  </tr>
  <tr> 
  	  <td colspan=2>5. 평가적용 위약금 면제금액 = 이전차 위약금 면제금액 - 신계약 월대여료총액의 3% (계약월대여료*계약기간*3%) </td>
  </tr>
  <tr> 
  	  <td colspan=2>6. 위약금 발생 </td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 고객과 계약한 위약금율에 상관없이 규정위약금율 적용</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> 규정위약금율(신차) : 일반차량 30%, 수입차 35%, 리무진 40%
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * 재리스/연장은 재리스정산/연장정산을 통해서 영업효율 마이너스 처리로 대체함 </td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> 마이너스 처리 값 = 실이용기간영업효율 - 계약기간 영업효율</tr>  
  <tr> 
  	  <td colspan=2>7. 추가이용은 최초영업자(또는 연장 계약담당자)에게 50%, 현재 영업담당자에게 50% 귀속됨 </td>
  </tr>  
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 계약승계수수료 : 현재 영업담당자에게 100% 귀속</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * 위 두가지를 제외한 모든 영업효율은 최초영업자(또는 연장 계약담당자)와 영업대리인에게 귀속됨 </td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> 영업대리인에게 주어지는 비율 : 20% (계약시 약정에 따라 가감)</td>
  </tr>
  <tr>
    <td colspan=2>8. 평가반영 기준일</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * 신차/재리스/연장 - 대여개시일</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * 재리스정산/연장정산/추가이용 - 해지일자</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * 계약승계수수료 - 승계일자</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * 신차위약금발생 - 해지일자 </td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * 신차위약금수금/재리스위약금수금/연장위약금수금 - 수금일자</td>
  </tr>
  <tr>
    <td colspan=2>9. 모든 영업효율의 평가는 2008-12-01 이후 대여개시된 건에만 적용 (단, 계약승계수수료는 대여개시일 따지지 않음) </td>
  </tr>
  </table>
</form>
</body>
</html>
