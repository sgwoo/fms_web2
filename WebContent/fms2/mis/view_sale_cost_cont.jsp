<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	//비용캠페인변수 : cost_campaign 테이블
	Hashtable ht3 = ac_db.getCostCampaignVar2("2");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
	String second_per	= (String)ht3.get("SECOND_PER");
	
	Hashtable ht = ac_db.getSaleCostCampaignCase_20081208(rent_mng_id, rent_l_cd, rent_st, cs_dt, ce_dt, second_per);
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

<!--
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}
//-->	
	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
<input type="hidden" name="second_per" value="<%=second_per%>">
<table border="0" cellspacing="0" cellpadding="0" width="4740">
  <tr> 
  	  <td align='right' colspan=2>&nbsp;&nbsp;</td>
  </tr>
  <tr> 
  	  <td class=line2 colspan=2></td>
  </tr>
  <tr id='tr_title' >  
	<td class='line' width='680' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=91>        
          <tr> 
           <td width='30' class='title' rowspan=2>연번</td>
           <td width='50' class='title' rowspan=2>최초<br>영업자</td>
		   <td width='50' class='title' rowspan=2>영업<br>대리인</td>
           <td width='100' class='title' rowspan=2>고객명</td>
           <td width='100' class='title' rowspan=2>차종</td>
           <td width='100' class='title' rowspan=2>차량<br>번호</td>
           <td width='100' class='title' rowspan=2>계약대여료<br>현재가치</td>
           <td width='100' class='title' rowspan=2>영업<br>효율</td>
           <td width='50' class='title' rowspan=2>비율</td>
          </tr>        
        </table></td>
	<td class='line' width='4060'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=91>
         <tr>
            <td width='50' class='title' rowspan=3>차량<br>구분</td>
            <td width='50' class='title' rowspan=3>계약<br>구분</td>
            <td width='50' class='title' rowspan=3>용도<br>구분</td>
            <td width='50' class='title' rowspan=3>관리<br>구분</td>
            <td width='50' class='title' rowspan=3>계약<br>기간</td>      
            <td width='100' class='title' rowspan=3>대여<br>개시일</td>               		 
            <td width='50' class='title' rowspan=3>적용<br>등급</td>
            <td width='100' class='title' rowspan=3>정상<br>대여료</td>   
            <td width='100' class='title' rowspan=3>계약<br>대여료</td>           
            <td width="100" class='title' rowspan=3>할인율</td>
            <td width="100" class='title' rowspan=3>자체<br>출고<br>여부</td>
            <td width="110" class='title' rowspan=3>카드<br>결제금액</td>
         	<td class="title" colspan=9>견적관리비+기대마진+기타수익</td>
         	<td class="title" colspan=14>비용항목</td>
            <td class="title" colspan=9>기타영업효율반영값</td>
                           
          </tr>
          <tr>
          	<td width=100 class="title" rowspan=2>기본식<br>관리비</td>
            <td width=100 class="title" rowspan=2>일반식<br>추가관리비</td>
            <td width=100 class="title" rowspan=2>기대마진</td>
            <td width=100 class="title" rowspan=2>재리스<br>초기<br>영업비용</td>
            <td width=100 class="title" rowspan=2>재리스<br>중고차<br>평가이익</td>
            <td width=100 class="title" rowspan=2>카드결제<br>캐쉬백</td>
            <td width=100 class="title" rowspan=2>기타</td>   
            <td width=100 class="title" rowspan=2>합계</td> 
            <td width=50 class="title" rowspan=2>계약<br>대여료<br>대비</td> 			
            
            <td width=100 class="title" rowspan=2>기본식<br>최소<br>관리비용</td> 
            <td width=100 class="title" rowspan=2>일반식<br>최소<br>관리비용</td>  
            <td width=100 class="title" rowspan=2>재리스차량<br>수리비<br>(참고값)</td>
            <td width=100 class="title" rowspan=2>적용<br>재리스차량<br>수리비</td>  
            <td width=100 class="title" rowspan=2>메이커추가<br>탁송비용</td> 
            <td width=100 class="title" rowspan=2>썬팅비용</td> 
            <td width=100 class="title" rowspan=2>지급용품</td>  
            <td width=100 class="title" rowspan=2>견적미반영<br>서비스품목</td> 
            <td width=100 class="title" rowspan=2>차량인도<br>탁송비용</td>  			
            <td width=100 class="title" rowspan=2>차량인도<br>유류비</td>  
            <td width=100 class="title" rowspan=2>렌트<br>긴급출동<br>보험가입비</td> 			
            <td width=100 class="title" rowspan=2>기타<br>비용</td> 
            <td class="title" colspan=2>비용합계</td>  
            
            <td width=100 class="title" rowspan=2>메이커<br>정상D/C</td>  
            <td width=100 class="title" rowspan=2>메이커<br>추가D/C</td> 
            <td width=100 class="title" rowspan=2>잔가리스크<br>감소효과</td>  
            <td width=100 class="title" rowspan=2>대차계약<br>위약금면제<br>(참고값)</td> 
            <td width=100 class="title" rowspan=2>평가적용<br>위약금면제</td>  
            <td width=100 class="title" rowspan=2>계약승계<br>수수료</td>  
            <td width=100 class="title" rowspan=2>해지정산금</td>  
            <td width=100 class="title" rowspan=2>기타</td>  						
            <td width=100 class="title" rowspan=2>합계</td>               
         </tr>
         <tr>
            <td width=100 class="title" >실비용</td>  
            <td width=100 class="title" >평가치</td>   
          </tr>
          
        </table>
	</td>
  </tr>	
  <tr height=100>
	  <td class='line' width='680' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
         <%	      
            long t_af_amt[] 	= new long[1];
            long t_bc_s_g[] 	= new long[1];
        	long t_fee_s_amt[] 	= new long[1];
        	long t_trf_amt[] 	= new long[1];
        	long t_amt1[] 		= new long[1];
      		long t_amt2[] 		= new long[1];
        	long t_amt3[] 		= new long[1];
        	long t_amt4[] 		= new long[1];
        	long t_amt5[] 		= new long[1];
        	long t_amt6[] 		= new long[1];
        	long t_amt7[] 		= new long[1];
        	long t_amt8[] 		= new long[1];
        	long t_amt9[] 		= new long[1];
        	long t_amt10[] 		= new long[1]; 
        	long t_amt11[] 		= new long[1]; //재리스 차량수리비
        	long t_amt12[] 		= new long[1];  //평가적용제리스차량수리비
        	long t_amt13[] 		= new long[1];  //메이커추가탁송비용
        	long t_amt14[] 		= new long[1];  //차량인도비용
        	long t_amt15[] 		= new long[1];  //썬팅비용
        	long t_amt16[] 		= new long[1];  //지급용품
        	long t_amt17[] 		= new long[1];  //견적미반용서비스품목
        	long t_amt18[] 		= new long[1];  //차량인도유류비
      		long t_amt19[] 		= new long[1];  //기타비용
        	long t_amt20[] 		= new long[1];  //실비용합계
        	long t_amt21[] 		= new long[1]; //평가치합계
        	long t_amt22[] 		= new long[1];
        	long t_amt23[] 		= new long[1];
        	long t_amt24[] 		= new long[1];
        	long t_amt25[] 		= new long[1];
        	long t_amt26[] 		= new long[1];
        	long t_amt27[] 		= new long[1]; 
        	long t_amt28[] 		= new long[1]; 
        	long t_amt29[] 		= new long[1];  //
        	long t_amt30[] 		= new long[1];  //
		long t_amt31[] 		= new long[1];  //
		long t_amt33[] 		= new long[1];  //
		long t_amt43[] 		= new long[1];  //
		long t_amt44[] 		= new long[1];  //
        	
        	long t_f_amt8[] 	= new long[1]; 
        	long t_f_amt21[] 	= new long[1];  //
        	long t_f_amt30[] 	= new long[1];  //
        	
        	
        	long a_amt1[] 	= new long[1];
        	long a_amt2[] 	= new long[1]; 
        	long a_amt3[] 	= new long[1]; 
        	long l_amt1[] 	= new long[1];
        	long l_amt2[] 	= new long[1]; 
        	long l_amt3[] 	= new long[1]; 
        	
        	long ea_amt = 0;
        	long af_amt = 0; 
        	long bc_s_g = 0;
        	 
        	float f_af_amt= 0;
        	float f_fee_s_amt= 0;
        	
 		    
					for(int j=0; j<1; j++){
							
					    	t_f_amt8[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));  	//합계
						t_f_amt21[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));  //비용합계
						t_f_amt30[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));  //기타효율합계
						t_af_amt[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT"))); //계약대여료현재가치
					}
					
				ea_amt = AddUtil.parseLong(String.valueOf(ht.get("AMT8"))) - AddUtil.parseLong(String.valueOf(ht.get("AMT21"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT30"))); //영업효율
    				af_amt = AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
    				f_af_amt = AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
		%>
          <tr>
           	 <td align="center" width='30'><%//= i+1%></td> 
             <td align="center" width='50'><%=ht.get("USER_NM")%></td>
             <td align="center" width='50'><%=ht.get("BUS_AGNT_NM")%></td>			 
             <td align="center" width='100'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
             <td align="center" width='100'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
             <td align="center" width='100'><span title='<%=ht.get("CAR_NO")%>'><%=ht.get("CAR_NO")%></span></td>
             <td align="right" width='100'><%=Util.parseDecimal(String.valueOf(ht.get("AF_AMT")))%></td>
             <td align="right" width='100'><%= Util.parseDecimal(ea_amt)%></td>
             <td align="center" width='50'> 
             <% if (  af_amt == 0 ) { %> 0
             <% } else { %> 
             <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt/f_af_amt*100),1)%>
             <% } %>            
			 </td>               
          </tr>
        </table></td>
	<td class='line' width='4060' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%
						for(int j=0; j<1; j++){
						
						t_bc_s_g[j] += AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));//정상대여료	
						t_fee_s_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));//대여료		
						t_trf_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));//카드결재액												
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1")));				
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT2")));				
						t_amt3[j]  += AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
						t_amt4[j]  += AddUtil.parseLong(String.valueOf(ht.get("AMT4"))); 
						t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
					  	t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
					    	t_amt9[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
						t_amt10[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
						t_amt11[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT11"))); //재리스 차량수리비
						t_amt12[j] +=  AddUtil.parseLong(String.valueOf(ht.get("AMT12"))); //평가적용재리스 차량수리비
						t_amt13[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT13")));  // 
						t_amt14[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT14")));  //차량인도탁송
						t_amt15[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT15")));  //썬팅비용
						t_amt16[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT16")));  //지급용품
						t_amt17[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT17")));  //견적미반영서비스품목
						t_amt18[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT18")));  //차량인도유류비
						t_amt19[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT19")));  //기타비용
						t_amt20[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT20")));  //실비용
						t_amt21[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT21")));  //평가치
						t_amt22[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT22")));  //메이커판매dc
						t_amt23[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT23")));  //메이커추가dc
						t_amt24[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT24")));  //잔가리ㅅ크감소효과
						t_amt25[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT25")));  //대차이전시 위약금면제
						t_amt26[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT26")));  //평가적용위약금
						t_amt27[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT27")));  //승계수수료	
						t_amt28[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT28")));  //위약금
						t_amt29[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT29")));  //기타ㅣ
						t_amt30[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT30")));  //합계
						t_amt33[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT33")));  //렌트긴급출동보험가입비->임시운행보험료
						t_amt43[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT43"))); 
						t_amt44[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT44"))); 
						
					}
						
					bc_s_g = AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));	
					f_fee_s_amt = AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));		
					
								 
				%>
          <tr> 
             <td align="center" width='50'><%=ht.get("CAR_GU_NM")%></td>
             <td align="center" width='50'><%=ht.get("RENT_ST_NM")%></td>
             <td align="center" width='50'><%=ht.get("CAR_ST_NM")%></td>
             <td align="center" width='50'><%=ht.get("RENT_WAY_NM")%></td>
             <td align="center" width='50'><%=ht.get("CON_MON")%></td>
             <td align="center" width='100'><%=ht.get("RENT_START_DT")%></td>		  
	  		<td align="center" width='50'><%=ht.get("SPR_KD_NM")%></td>
            <td align="right" width='100'><%=Util.parseDecimal(String.valueOf(ht.get("BC_S_G")))%></td>
            <td align="right" width='100'><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%></td>
            <td align="right" width='100'>
            <% if (  bc_s_g == 0 ) { %>0<% } else { %><%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g-f_fee_s_amt)/(bc_s_g-t_amt43[0]-t_amt44[0] ) * 100),1)%><% } %>
            <%//=AddUtil.parseFloatCipher(Util.parseDecimal( (bc_s_g/f_fee_s_amt - 1) * 100),1)%>
            </td>
	    <td width="100" align="center"><%=ht.get("COMMI2_NM")%></td>
	    <td width="110" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>  <!--카드결재금액-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%></td>  <!--기본식관리비-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%></td>  <!--일반식관리비-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%></td>  <!--기대마진-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%></td>  <!--재리스초기영업비용-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT5")))%></td>  <!--재리스중고차평가이익-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT6")))%></td>  <!-- 카드결제캐쉬백-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT7")))%></td>  <!--기타-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT8")))%></td>  <!--합계 -->
            <td width="50" align="right">
			<% if (  AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT"))) == 0 ) { %> 0
             <% } else { %> 
             <%=AddUtil.parseFloatCipher(Util.parseDecimal(AddUtil.parseFloat(String.valueOf(ht.get("AMT8")))/AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")))*100),1)%>
             <% } %>
			</td>  <!--계약대여료대비 -->			
            
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT9")))%></td> <!--기본식최소관리비용 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT10")))%></td> <!--일반식최소관리비용 --> 
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT11")))%></td> <!--재리스차량수리비 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT12")))%></td> <!--적용재리스수리비 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT13")))%></td> <!--메이커추가탁송 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT15")))%></td> <!--썬팅비용 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT16")))%></td> <!--지급용품 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT17")))%></td> <!--견적미반영서비스품목 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT14")))%></td> <!--차량인도탁송비용  -->			
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT18")))%></td> <!--차량인도유류비 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT33")))%></td> <!--렌트긴급출동보험가입비->임시운행보험료 -->			
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT19")))%></td> <!--기타비용 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT20")))%></td> <!--실비용 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT21")))%></td> <!--평가치 -->
        
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT22")))%></td> <!--정상D/C -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT23")))%></td> <!--추가D/C -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT24")))%></td> <!--잔가리스크감소효과 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT25")))%></td> <!--대차계약위약금면제  -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT26")))%></td> <!--평가적용위약금면제 -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT27")))%></td> <!--기타  -->                   
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT28")))%></td> <!--기타  -->                   
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT29")))%></td> <!--기타  -->                   						
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT30")))%></td> <!--합계 -->
            
          </tr>
        </table>
	</td>
  </tr>
  <tr> 
  	  <td colspan=2>1. 특별한 언급이 없는 항목은 100% 만큼 수익 및 비용으로 처리함</td>
  </tr>
  <tr> 
  	  <td colspan=2>2. 참고값에 대한 설명</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 적용 재리스차량 수리비는 실 재리스차량 수리비의 50%로 함</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 메이커 정상D/C는 견적 산출시에만 반영하고, 메이커 추가D/C는 견적에도 반영하고 추가로 영업효율에 반영 (최대100만원)</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 메이커D/C중 탁송료 추가발생에 따른 D/C(추가탁송료D/C)는 정상D/C 금액에 포함</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 평가 적용 위약금 면제금액 = 대차계약 위약금 면제금액 - 대차계약 월대여료 총액의 3%</td>
  </tr>
  <tr> 
  	  <td colspan=2>3. 기타 주요 사항</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 계약기간은 위약금적용 계약기간임( = 계약서상 계약기간 - 위약금 면제 개월수 )</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 정상대여료는 위약금 적용 계약기간 기준, 대여개시일 기준 재산정</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 일반식 최소관리비용은 초우량 일반식추가관리 비용을 적용</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * 메이커 추가탁송비용 = 실 지불메이커 탁송료 -  견적프로그램상의 메이커 탁송료</td>
  </tr>  
  </table>
</form>
</body>
</html>
