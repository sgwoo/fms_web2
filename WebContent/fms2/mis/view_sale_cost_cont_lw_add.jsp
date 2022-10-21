<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cont.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("add_rent_st")==null?"":request.getParameter("add_rent_st");
	
	//비용캠페인변수 : cost_campaign 테이블
	Hashtable ht3 = ac_db.getCostCampaignVar2("2");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
	String second_per	= (String)ht3.get("SECOND_PER");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	ContCarBean fee_etc = a_db.getContFeeEtcAdd(rent_mng_id, rent_l_cd, rent_st);
	
	String cost_st = "";
	
	if(rent_st.equals("a")) cost_st="2";
	if(rent_st.equals("s")) cost_st="6";
	if(rent_st.equals("t")) cost_st="9";
	
	//월렌트정산
	if(rent_st.equals("s") && base.getCar_st().equals("4")){
	 	cost_st="14";
	}
	
	Hashtable ht = ac_db.getSaleCostCampaignBcCase(cost_st, rent_mng_id, rent_l_cd, rent_st);
	
	//Hashtable ht = ac_db.getSaleCostCampaignAddCase_20090302(rent_mng_id, rent_l_cd, rent_st, cs_dt, ce_dt, second_per);
	
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
        	long t_amt29[] 		= new long[1];
        	long t_amt30[] 		= new long[1];
		long t_amt31[] 		= new long[1];
		long t_amt33[] 		= new long[1];
		long t_amt34[] 		= new long[1];
		long t_amt35[] 		= new long[1];
		long t_amt36[] 		= new long[1];
		long t_amt39[] 		= new long[1];
		long t_amt40[] 		= new long[1];
		long t_amt41[] 		= new long[1];
		long t_amt42[] 		= new long[1];
		long t_amt43[] 		= new long[1];
		long t_amt44[] 		= new long[1];
		long t_amt45[] 		= new long[1];
		long t_amt46[] 		= new long[1];
        	
        	long t_f_amt8[] 	= new long[1];
        	long t_f_amt21[] 	= new long[1];
        	long t_f_amt30[] 	= new long[1];
        	
        	
        	long a_amt1[] 	= new long[1];
        	long a_amt2[] 	= new long[1];
        	long a_amt3[] 	= new long[1];
        	long l_amt1[] 	= new long[1];
        	long l_amt2[] 	= new long[1];
        	long l_amt3[] 	= new long[1];
        	
        	long ea_amt = 0;
        	long af_amt = 0;
        	long bc_s_g = 0;
			long bc_s_c = 0;
        	
        	float f_af_amt= 0;
        	float f_fee_s_amt= 0;
        	
 		    
					for(int j=0; j<1; j++){
						
					    t_f_amt8[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));  	//합계
						t_f_amt21[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));  //비용합계
						t_f_amt30[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));  //기타효율합계
						t_af_amt[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT"))); //계약대여료현재가치
						
						t_bc_s_g[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));//정상대여료	
						t_fee_s_amt[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));//대여료
						t_trf_amt[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));//카드결재액
						t_amt1[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
						t_amt2[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
						t_amt3[j]  		+= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
						t_amt4[j]  		+= AddUtil.parseLong(String.valueOf(ht.get("AMT4"))); 
						t_amt5[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
						t_amt6[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
						t_amt7[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
					    if(AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")))>0)	t_amt8[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
					    t_amt9[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
						t_amt10[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
						t_amt11[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT11"))); 	//재리스 차량수리비
						t_amt12[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT12"))); 	//평가적용재리스 차량수리비
						t_amt13[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT13")));  // 
						t_amt14[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT14")));  //차량인도탁송
						t_amt15[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT15")));  //썬팅비용
						t_amt16[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT16")));  //지급용품
						t_amt17[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT17")));  //견적미반영서비스품목
						t_amt18[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT18")));  //차량인도유류비
						t_amt19[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT19")));  //기타비용
						if(AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")))>0)	t_amt20[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT20")));  //실비용
						if(AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")))>0)	t_amt21[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));  //평가치
						t_amt22[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT22")));  //메이커판매dc
						t_amt23[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT23")));  //메이커추가dc
						t_amt24[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT24")));  //잔가리ㅅ크감소효과
						t_amt25[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT25")));  //대차이전시 위약금면제
						t_amt26[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT26")));  //평가적용위약금
						t_amt27[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT27")));  //승계수수료	
						t_amt28[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT28")));  //위약금
						t_amt29[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT29")));  //기타ㅣ
						if(AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")))>0)	t_amt30[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));  //합계
						t_amt33[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT33")));  //렌트긴급출동보험가입비->임시운행보험료
						t_amt34[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT34")));  //고객피보험
						t_amt35[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT35")));  //출고보전수당
						t_amt36[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT36")));  //실적이관권장수당
						t_amt39[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT39")));  //에이전트업무진행수당
						t_amt40[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT40")));  //카드결제캐쉬백견적반영분
						t_amt41[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT41")));  //출고보전수당견적반영분
						t_amt42[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT42")));  //용품사양
						t_amt43[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT43")));  //선납금효과
						t_amt44[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT44")));  //용품월대여료
						t_amt45[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT45")));  //용품견적반영분
						t_amt46[j] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT46")));  //재리스지점간이동탁송료
						
					}
					
					bc_s_g 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					bc_s_c 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_C")));
					f_fee_s_amt = AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					
					ea_amt 		= AddUtil.parseLong(String.valueOf(ht.get("AMT8"))) - AddUtil.parseLong(String.valueOf(ht.get("AMT21"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT30"))); //영업효율
    				af_amt 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
    				f_af_amt 	= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					
					//if(bc_s_c==0) ea_amt=0;
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

function cmp_help_cont(){
		var SUBWIN= "view_sale_cost_help.jsp";
		window.open(SUBWIN, "View_Help", "left=50, top=50, width=820, height=700, resizable=yes, scrollbars=yes");
}
//-->	
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="second_per" value="<%=second_per%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rent_st" value="<%=rent_st%>">
<input type="hidden" name="cs_dt" value="<%=cs_dt%>">
<input type="hidden" name="ce_dt" value="<%=ce_dt%>">

  <table border="0" cellspacing="0" cellpadding="0" width="800">
    <tr>
      <td>&nbsp;</td>
    </tr>  
    <tr> 
  	  <td class=line2></td>
    </tr>	
    <tr> 
  	  <td class=line><table border="0" cellspacing="1" cellpadding="0" width='800' >
        <tr>
          <td class='title'>최초영업자</td>
          <td class='title'>영업대리인</td>
          <td colspan="2" class='title'>고객명</td>
          </tr>
        <tr>
          <td align="center"><%=ht.get("USER_NM")%></td>
          <td align="center"><%=ht.get("BUS_AGNT_NM")%></td>
          <td colspan="2" align="center"><%=ht.get("FIRM_NM")%></td>
        </tr>
        <tr>
          <td height="28" colspan="2" class='title'>차종</td>
          <td colspan="2" class='title'>차량번호</td>
        </tr>
        <tr>
          <td colspan="2" align="center"><%=ht.get("CAR_NM")%></td>
          <td colspan="2" align="center"><%=ht.get("CAR_NO")%></td>
          </tr>
        <tr>
          <td width='200' class='title'>차량구분</td>
          <td width='200' class='title'>계약구분</td>
          <td width='200' class='title'>용도구분</td>
          <td width='200' class='title'>관리구분</td>
          </tr>
        <tr>
          <td align="center" width='200'><%=ht.get("CAR_GU_NM")%></td>
          <td align="center" width='200'><%=ht.get("RENT_ST_NM")%></td>
          <td align="center" width='200'><%=ht.get("CAR_ST_NM")%></td>
          <td align="center" width='200'><%=ht.get("RENT_WAY_NM")%></td>
          </tr>
        <tr>
          <td width='200' class='title'>계약기간</td>
          <td width='200' class='title'>대여개시일</td>
          <td width='200' class='title'>적용등급</td>
          <td width="200" class='title'>자체출고여부</td>
          </tr>
        <tr>
          <td align="center" width='200'><%=ht.get("CON_MON")%></td>
          <td align="center" width='200'><%=ht.get("RENT_START_DT")%></td>
          <td align="center" width='200'><%=ht.get("SPR_KD_NM")%></td>
          <td width="200" align="center"><%=ht.get("COMMI2_NM")%></td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class=line><table border="0" cellspacing="1" cellpadding="0" width='800' >
        <tr>
          <td colspan="3" class=title>계약대여료현재가치</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AF_AMT")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" class=title>영업효율</td>
          <td align="right"><b><%= Util.parseDecimal(ea_amt)%></b>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" class=title>비율</td>
          <td align="right"><% if (  af_amt == 0 ) { %>0<% } else { %><%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt/f_af_amt*100),1)%><% } %>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" class=title>정상대여료</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BC_S_G")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" class=title>계약대여료</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" class=title>할인율</td>
          <td align="right"><% if (  bc_s_g == 0 ) { %>0<% } else { %><%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g-f_fee_s_amt)/(bc_s_g-t_amt43[0]-t_amt44[0]) ) * 100),1)%><% } %>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" class=title>카드결제금액</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%>&nbsp;</td>
        </tr>
        <tr>
          <td rowspan="16" class=title>견적관리비+기대마진+기타수익</td>
          <td colspan="2" class=title>기본식관리비</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>일반식추가관리비</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>기대마진</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>고객피보험자보험료</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT34")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>재리스초기영업비용</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>재리스중고차평가이익</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT5")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>카드결제캐쉬백</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT6")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>카드결제캐쉬백견적반영분</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT40")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>출고보전수당</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT35")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>출고보전수당견적반영분</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT41")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>실적이관권장수당</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT36")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>에이전트업무진행수당</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT39")))%>&nbsp;</td>
        </tr>
        <!--
        <tr>
          <td colspan="2" class=title>용품사양</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT42")))%>&nbsp;</td>
        </tr>
        -->
        <tr>
          <td colspan="2" class=title>재리스지점간이동탁송료견적반영분</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT46")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>기타</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT7")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>합계</td>
          <td align="right" class=is><b><%=Util.parseDecimal(String.valueOf(ht.get("AMT8")))%></b>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>계약대여료대비</td>
          <td align="right"><% if (  AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT"))) == 0 ) { %> 0
             <% } else { %> 
             <%=AddUtil.parseFloatCipher(Util.parseDecimal(AddUtil.parseFloat(String.valueOf(ht.get("AMT8")))/AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")))*100),1)%>
            <% } %>&nbsp;</td>
        </tr>
        <tr>
          <td width="200" rowspan="16" class=title>비용항목</td>
          <td colspan="2" class=title>기본식최소관리비용</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT9")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>일반식최소관리비용</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT10")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>재리스차량수리비(참고값)</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT11")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>적용재리스차량수리비</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT12")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>메이커추가탁송비용</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT13")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>썬팅비용</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT15")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>지급용품</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT16")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>견적미반영서비스품목</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT17")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>차량인도탁송비용</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT14")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>차량인도유류비</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT18")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>임시운행보험료</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT33")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>재리스지점간이동탁송료견적반영분</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT46")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>기타비용</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT19")))%>&nbsp;</td>
        </tr>
        <tr>
          <td width="200" rowspan="3" class=title>비용합계</td>
          <td width="200" class=title>실비용</td>
          <td width="200" align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("AMT20")))%>&nbsp;</td>
        </tr>
        <tr>
          <td class=title>용품견적반영분</td>
          <td align="right">&nbsp;<b><%=Util.parseDecimal(String.valueOf(ht.get("AMT45")))%></b>&nbsp;</td>
        </tr>        
        <tr>
          <td class=title>평가치</td>
          <td align="right" class=is>&nbsp;<b><%=Util.parseDecimal(String.valueOf(ht.get("AMT21")))%></b>&nbsp;</td>
        </tr>
        <tr>
          <td <%if(AddUtil.parseLong(String.valueOf(ht.get("AMT22")))+AddUtil.parseLong(String.valueOf(ht.get("AMT23"))) == 0){%>rowspan="7"<%}else{%>rowspan="9"<%}%> class=title>기타영업효율반영값</td>
          <td colspan="2" class=title>잔기리스크감소효과</td>
          <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("AMT24")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>대차계약위약금면제(참고값)</td>
          <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("AMT25")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>평가적용위약금면제</td>
          <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("AMT26")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>계약승계수수료</td>
          <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("AMT27")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>해지정산금</td>
          <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("AMT28")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>기타</td>
          <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("AMT29")))%>&nbsp;</td>
        </tr>
        <%if(AddUtil.parseLong(String.valueOf(ht.get("AMT22")))+AddUtil.parseLong(String.valueOf(ht.get("AMT23"))) > 0){%>
        <tr>
          <td colspan="2" class=title>메이커정상D/C(참고값)</td>
          <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("AMT22")))%>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class=title>메이커추가D/C(반영값)</td>
          <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("AMT23")))%>&nbsp;</td>
        </tr>        
        <%}%>
        <tr>
          <td colspan="2" class=title>합계</td>
          <td align="right" class=is><b><%=Util.parseDecimal(String.valueOf(ht.get("AMT30")))%></b>&nbsp;</td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td align="center"><a href='javascript:cmp_help_cont()' title='설명문'><img src=/acar/images/center/button_exp.gif border=0 align=absmiddle></a></td>
    </tr>	
	<tr>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td>&nbsp;</td>
    </tr>
	
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding='0' width=100%>
                <tr>
            	    <td class=line2></td>
            	</tr>
    		    <tr>
        		    <td class=line width="100%">
        			    <table border="0" cellspacing="1" cellpadding='0' width=100%>
            		        <tr>
            				  <td width="13%" class=title>기호</td>
            				  <td width="11%" class=title>코드</td>				  
            				  <td width="28%" class=title>이름</td>
            				  <td width="28%" class=title>값</td>
            				  <td width="20%" class=title>-</td>				  
            				</tr>
            		        <tr>
            				  <td align="center">a</td>
            				  <td align="center">bc_s_a</td>				  
            				  <td>10만원당월할부금</td>
            				  <td align="center"><input type='text' size='12' name='bc_s_a' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_a()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				  <td rowspan='18' align="center">
            				  </td>				  
            				</tr>
            		        <tr>
            				  <td align="center">b</td>
            				  <td align="center">bc_s_b</td>				  
            				  <td>계약기간</td>
            				  <td align="center"><input type='text' size='12' name='bc_s_b' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_b()%>'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">c</td>
            				  <td align="center">bc_s_c</td>				  
            				  <td>기준대여료</td>
            				  <td align="center"><input type='text' size='12' name='bc_s_c' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_c()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">d</td>
            				  <td align="center">bc_s_d</td>				  
            				  <td>목표마진율</td>
            				  <td align="center"><input type='text' size='12' name='bc_s_d' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_d()%>'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">e</td>
            				  <td align="center">bc_s_e</td>				  
            				  <td>적용잔가율조정에따른대여료요금할인율</td>
            				  <td align="center"><input type='text' size='12' name='bc_s_e' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_e()%>'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">f</td>
            				  <td align="center">bc_s_f</td>				  
            				  <td>자체출고요율</td>
            				  <td align="center"><input type='text' size='12' name='bc_s_f' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_f()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">g</td>
            				  <td align="center">bc_s_g</td>				  
            				  <td>정상대여료</td>
            				  <td align="center"><input type='text' size='12' name='bc_s_g' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">i</td>
            				  <td align="center">bc_s_i</td>				  
            				  <td>캐쉬백율</td>
            				  <td align="center"><input type='text' size='12' name='bc_s_i' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_i()%>'>&nbsp;</td>
            				</tr>
            				<tr>
            				  <td align="center">i2</td>
            				  <td align="center">bc_s_i2</td>				  
            				  <td>캐쉬백율(국산차)</td>
            				  <td align="center"><input type='text' size='12' name='bc_s_i' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_i2()%>'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">A</td>
            				  <td align="center">bc_b_a</td>				  
            				  <td>기본식관리비</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_a' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_a()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">B</td>
            				  <td align="center">bc_b_b</td>				  
            				  <td>일반식추가관리비</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_b' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_b()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">D</td>
            				  <td align="center">bc_b_d</td>				  
            				  <td>재리스초기영업비용</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_d' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_d()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">K</td>
            				  <td align="center">bc_b_k</td>				  
            				  <td>일반식최소관리비용</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_k' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_k()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">N</td>
            				  <td align="center">bc_b_n</td>				  
            				  <td>견적메이커탁송료</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_n' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_n()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				</tr>
            		        <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>기타수익</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='num' value='<%=fee_etc.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='20' name='bc_b_g_cont' maxlength='30' class=text value='<%=fee_etc.getBc_b_g_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>기타비용</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='num' value='<%=fee_etc.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='20' name='bc_b_u_cont' maxlength='30' class=text value='<%=fee_etc.getBc_b_u_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>기타 영업효율반영값</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='num' value='<%=fee_etc.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
    </tr>		
	  
  </table>
</form>
</body>
</html>
