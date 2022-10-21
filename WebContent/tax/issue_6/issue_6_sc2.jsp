<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*, acar.car_office.*"%>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	NeoErpUDatabase 	neoe_db = NeoErpUDatabase.getInstance();
	
	String tax_no	 	= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String car_off_id 	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	int tae_sum = 0;
	int max_table_line = 3;
	int height = 0;
	String tax_supply = "";
	String tax_value = "";
	String tax_st = "O";
	
	if(car_off_id.equals("")) return;
	
	//공급자
	Hashtable br = c_db.getBranch(br_id);
	
	Vector branches = c_db.getBranchs(); //영업소 리스트 조회
	int brch_size = branches.size();
		
	//공급받는자-영업소
	co_bean = cod.getCarOffBean(car_off_id);
	
	Hashtable ven = neoe_db.getTradeCase(ven_code);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//발행
	function tax_reg(){
		var fm = document.form1;
		
		return;
		
		if(fm.doc_st[0].checked == true){			
			//20140101 세금계산서 -발행은 안됨			
			if(toInt(parseDigit(fm.tax_amt.value)) < 0){
				alert('마이너스발행은 할 수 없습니다.');
				return;
			}
			if(fm.req_y.value == '' || fm.req_m.value == '' || fm.req_d.value == ''){	alert('세금계산서 작성일자를 입력하십시오.'); return; }
			if(fm.tax_bigo.value == ''){	alert('세금계산서 비고를 입력하십시오.'); return; }			
		}
		

		if(confirm('직접발행 하시겠습니까?'))
		{			
			fm.target = "i_no";
			fm.action = "tax_reg_step1.jsp";
			fm.submit();						
		}
	}

	//공급자 셋팅
	function out_set(){
		var fm = document.form1;
		var o_brch = fm.o_enp_no.options[fm.o_enp_no.selectedIndex].value;
		var o_brch_split 	= o_brch.split(",");
		fm.o_br_id.value 	= o_brch_split[0];
		fm.o_addr.value 	= o_brch_split[1];
		fm.o_item.value 	= o_brch_split[2];
		fm.o_sta.value 		= o_brch_split[3];				
	}
	
	//공급받는자 셋팅
	function in_set(){
		var fm = document.form1;
		var i_brch = fm.i_enp_no.options[fm.i_enp_no.selectedIndex].value;
		var i_brch_split 	= i_brch.split(",");
		fm.i_site_id.value 	= i_brch_split[0];
		fm.i_firm_nm.value 	= i_brch_split[1];
		fm.i_client_nm.value= i_brch_split[2];
		fm.i_addr.value 	= i_brch_split[3];				
		fm.i_item.value 	= i_brch_split[4];
		fm.i_sta.value 		= i_brch_split[5];			
	}	
	
	//목록가기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "issue_6_frame2.jsp";
		fm.submit();
	}
	
	//세금계산서 금액셋팅
	function set_tax_amt(){
		var fm = document.form1;	
		
		var s_len = parseDigit(fm.tax_supply.value).length;
		var v_len = parseDigit(fm.tax_value.value).length;		
		fm.gongran.value 			= 11-s_len;
		var cnt = 0;
		for(i=11-s_len;i<11;i++){//공급가
			fm.s_amt[i].value = parseDigit(fm.tax_supply.value).charAt(cnt);
			cnt++;
		}		
		cnt = 0;
		for(i=10-v_len;i<10;i++){//부가세
			fm.v_amt[i].value = parseDigit(fm.tax_value.value).charAt(cnt);
			cnt++;
		}		
	}
	//거래명세서 금액셋팅
	function set_amt(idx){
		var fm = document.form1;	
		
		fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));
		
		fm.t_item_supply.value = 0;
		fm.t_item_value.value = 0;
		fm.t_item_amt.value = 0;				
		
		for(i=0; i<15; i++){
			fm.t_item_supply.value 	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));
			fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));
		}		
		fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));		
		
		fm.tax_supply.value			= fm.t_item_supply.value;
		fm.tax_value.value			= fm.t_item_value.value;
		fm.tax_amt.value			= fm.t_item_amt.value;
		
		set_tax_amt();			
	}	
	
//-->
</script>

</head>
<body>
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%//=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">  
  <input type="hidden" name="car_off_id" value="<%=car_off_id%>">  
  <input type="hidden" name="ven_code" value="<%=ven_code%>">  
  <input type="hidden" name="mode" value="<%=mode%>">  
  <input type="hidden" name="scd_size" value="<%//=til_size%>">
  <input type="hidden" name="count" value="0">
  
<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
      	<tr><td class=line2 style='height:1'></td></tr>
        <tr>
          <td width='10%' class='title'>구분</td>
          <td width='90%'>&nbsp;
		      <input type="radio" name="doc_st" value="1" checked>
              세금계산서
              <input type="radio" name="doc_st" value="2" >
              거래명세서
			  </td>
          </tr>
      </table></td>
    </tr>	
    <tr>
      <td colspan="2">
        <table width="100%"  border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="49%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>공급받는자</span></td>
              <td width="1%">&nbsp;</td>
              <td width="50%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>공급자</span></td>
            </tr>
            <tr>
                <td class="line">
                    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          	          	<tr><td class=line2 style='height:1'></td></tr>
                        <tr>
                          <td width='20%' class='title'>등록번호</td>
                          <td colspan="3">&nbsp;
            			  <input type="hidden" name="i_site_id" value="<%//=site_id%>">
            			  <select name='i_enp_no' onChange='javascript:in_set();'>
            		              <option value='00,<%=co_bean.getCar_off_nm()%>,<%=co_bean.getOwner_nm()%>,<%=co_bean.getCar_off_addr()%>,<%=ven.get("TP_JOB")%>,<%=ven.get("CLS_JOB")%>' selected><%=co_bean.getEnp_no()%></option>				  
            		          </select>			 			    
            		  </td>
                        </tr>
                        <tr>
                          <td class='title'>상호(법인명)</td>
                          <td colspan="3">&nbsp;<input type="text" name="i_firm_nm" size="50" value="<%=co_bean.getCar_off_nm()%>" class="whitetext" readonly></td>
                          </tr>
                        <tr>
                          <td class='title'>성명</td>
                          <td colspan="3">&nbsp;<input type="text" name="i_client_nm" size="50" value="<%=co_bean.getOwner_nm()%>" class="whitetext" readonly></td>
                          </tr>
                        <tr>
                          <td class='title'>사업장주소</td>
                          <td colspan="3">&nbsp;<input type="text" name="i_addr" size="50" value="<%=co_bean.getCar_off_addr()%>" class="whitetext" readonly></td>
                        </tr>
                        <tr>
                          <td class='title'>업태</td>
                          <td width="30%">&nbsp;<input type="text" name="i_sta" size="16" value="<%=ven.get("TP_JOB")%>" class="whitetext" readonly></td>
                          <td width="15%" class='title'>종목</td>
                          <td width="35%">&nbsp;<input type="text" name="i_item" size="20" value="<%=ven.get("CLS_JOB")%>" class="whitetext" readonly></td>
                        </tr>
                </table>
           </td>
          <td>&nbsp;</td>
          <td class="line">
                <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          	        <tr><td class=line2 style='height:1'></td></tr>
                    <tr>
                      <td width='20%' class='title'>등록번호</td>
                      <td colspan="3">&nbsp;
        			    <input type="hidden" name="o_br_id" value="<%=br.get("BR_ID")%>">  
        			    <select name='o_enp_no' onChange='javascript:out_set();'>
        		          <option value=''>선택</option>
                  			<%	if(brch_size > 0){
        							for (int i = 0 ; i < brch_size ; i++){
        								Hashtable branch = (Hashtable)branches.elementAt(i);%>
        			      <option value='<%=branch.get("BR_ID")%>,<%=branch.get("BR_ADDR")%>,<%=branch.get("BR_ITEM")%>,<%=branch.get("BR_STA")%>'  <%if(br.get("BR_ID").equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= AddUtil.ChangeEnp(String.valueOf(branch.get("BR_ENT_NO")))%> <%= branch.get("BR_NM")%></option>
                  			<%		}
        						}%>
        		        </select>			  
        			  </td>
                    </tr>
                    <tr>
                      <td class='title'>상호(법인명)</td>
                      <td colspan="3">&nbsp;(주)아마존카</td>
                    </tr>
                    <tr>
                      <td class='title'>성명</td>
                      <td colspan="3">&nbsp;<%=br.get("BR_OWN_NM")%></td>
                    </tr>
                    <tr>
                      <td class='title'>사업장주소</td>
                      <td colspan="3">&nbsp;<input type="text" name="o_addr" size="50" value="<%=br.get("BR_ADDR")%>" class="whitetext" readonly></td>
                    </tr>
                    <tr>
                      <td class='title'>업태</td>
                      <td width="30%">&nbsp;<input type="text" name="o_sta" size="16" value="<%=br.get("BR_STA")%>" class="whitetext" readonly></td>
                      <td width="15%" class='title'>종목</td>
                      <td width="35%">&nbsp;<input type="text" name="o_item" size="20" value="<%=br.get("BR_ITEM")%>" class="whitetext" readonly></td>
                    </tr>
                </table>
            </td>
        </tr>
      </table></td>
    </tr>		
    <tr>
      <td colspan="2" class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래명세서</span></td>
      <td align="right">
	  </td>
    </tr>	
    <tr>
      <td colspan="2" class="line">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="center" bgcolor="#CCCCCC">
          <td rowspan="2" width="5%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
          <td rowspan="2" width="45%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
          <!--
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
          <td width="25%" rowspan="2" bgcolor="#CCCCCC" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차명</td>
          -->
          <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구(거래)기준일</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">합계</td>
        </tr>
        <tr>
          <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~부터</td>
          <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~까지</td>
        </tr>
		<%for(int i =0; i<15; i++){%>
		<input type='hidden' name="l_cd">
		<input type='hidden' name="c_id">		
		<input type='hidden' name="tm">		
		<input type='hidden' name="seq" value="<%=i+1%>">
        <tr>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=i+1%></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_g" size="50" value="" class="taxtext" onBlur='javascript:document.form1.tax_g.value=this.value;'>
          </span></td>
          <!--
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_car_no" size="12" value="" class="taxtext" onBlur='javascript:document.form1.tax_bigo.value=this.value;'>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_car_nm" size="25" value="" class="taxtext">
          </span></td>
          -->
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_dt1" size="10" value="" class="taxtext">
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_dt2" size="10" value="" class="taxtext">
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_supply" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(<%=i%>);'> 
            </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_value" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(<%=i%>);'>
			</span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_amt" size="10" value="" class="whitenum" onBlur='javascript:this.value=parseDecimal(this.value);'>
			</span></td>
        </tr>
		<%}%>	
        <tr>
          <td height="22" colspan="4" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">합계</td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="t_item_supply" size="10" value="" class="whitenum" readonly>
			</span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="t_item_value" size="10" value="" class="whitenum" readonly>
			</span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="t_item_amt" size="10" value="" class="whitenum" readonly>
			</span></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td colspan="2" class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서</span></td>
      <td align="right">
	  </td>
    </tr>	
	  <input type="hidden" name="tax_no" value="">
    <tr>
      <td colspan="2">
        <table style="BORDER-COLLAPSE: collapse" cellspacing=0 cellpadding=0 width=100%>
        <tbody>
          <tr align="center">
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=3 height=25>작 성</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=12 height=25>공 &nbsp;&nbsp;&nbsp;&nbsp;급 &nbsp;&nbsp;&nbsp;가 &nbsp;&nbsp;&nbsp;액</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=10 height=25>세 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=36% height=25>비 &nbsp;고</td>
          </tr>
          <tr>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=8% height=25 align="center">년</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center">월</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center">일</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=6% height=25 align="center">공란수</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">억</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">천</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">만</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">천</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">일</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">억</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">천</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">만</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">천</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">일</td>
            <td rowspan=2 align="center" class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid"><span class="ledger_contC">
              <input type="text" name="tax_bigo" size="40" value="" class="taxtext">
            </span></td>
          </tr>
          <tr>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_y" size="4" value="<%//=AddUtil.getDate(1)%>" class="taxtext"></td>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_m" size="2" value="<%//=AddUtil.getDate(2)%>" class="taxtext" onBlur="javascript:document.form1.tax_m.value=this.value;"></td>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_d" size="2" value="<%//=AddUtil.getDate(3)%>" class="taxtext" onBlur="javascript:document.form1.tax_d.value=this.value;"></td>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="gongran" size="1" value="" class="taxtext"></td>
            <%for(int i=0; i<11-tax_supply.length(); i++){%>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="s_amt" size="1" value="" class="whitetext"></td>
            <%}%>
            <%for(int i=0; i<tax_supply.length(); i++){%>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="s_amt" size="1" value="" class="whitetext"></td>
            <%}%>
            <%for(int i=0; i<10-tax_value.length(); i++){%>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="v_amt" size="1" value="" class="whitetext"></td>
            <%}%>
            <%for(int i=0; i<tax_value.length(); i++){%>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="v_amt" size="1" value="" class="whitetext"></td>
            <%}%>
          </tr>
        </tbody>
      </table>
        <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
          <tbody>
          <tbody>
            <tr>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=2 height=30 align="center">월&nbsp;&nbsp;일</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=26% height=30 align="center">품&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=10% height=30 align="center">규 격</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=10% height=30 align="center">수 량</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=10% height=30 align="center">단 가</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=30 align="center">공급가액</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=30 align="center">세 액</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=6% height=30 align="center">비 고</td>
            </tr>
            <tr>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_m" size="2" value="" class="whitetext"></td>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_d" size="2" value="" class="whitetext"></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25>&nbsp;<span class="ledger_contC">
                <input type="text" name="tax_g" size="25" value="" class="taxtext">
              </span> </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25><nobr></nobr></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                <input type="text" name="tax_supply" size="11" value="" class="whitenum" readonly>
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                <input type="text" name="tax_value" size="10" value="" class="whitenum" readonly>
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
            </tr>
          </tbody>
        </table>
        <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
          <tbody>
          <tbody>
            <tr>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">합계금액</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">현 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;금</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;표</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">어&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;음</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=25 align="center">외 상 미 수 금</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" align=middle width=21% rowspan=2><table cellspacing=0 cellpadding=0 width=140 border=0>
                  <tbody>
                    <tr class=ledger_titleB>
                      <td width="47%">이금액을</td>
                      <td width="45%"><input type="radio" name="pubform" value="R" >영수<br>
                          <input type="radio" name="pubform" value="D" checked >청구 </td>
                      <td width="8%">함</td>
                    </tr>
                  </tbody>
              </table></td>
            </tr>
            <tr>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=30 align="center"><span class="ledger_contC">
                <input type="text" name="tax_amt" size="11" value="" class="whitenum">
              </span>원</td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
            </tr>
          </tbody>
        </table></td>
    </tr>	
    <tr>
      <td colspan="2" class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전자세금계산서 이메일 발송</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='10%' class='title'>이름</td>
          <td width='20%'>&nbsp;<input type='text' size='15' name='con_agnt_nm' value='<%//=client.getCon_agnt_nm()%>' maxlength='20' class='text'></td>
          <td width="10%" class='title'>근무부서</td>
          <td width="20%">&nbsp;
              <input type='text' size='15' name='con_agnt_dept' value='<%//=client.getCon_agnt_dept()%>' maxlength='15' class='text'></td>
          <td width="10%" class='title'>직위</td>
          <td width="30%">&nbsp;
              <input type='text' size='15' name='con_agnt_title' value='<%//=client.getCon_agnt_title()%>' maxlength='10' class='text'></td>
          </tr>
        <tr>
          <td class='title'>EMAIL</td>
          <td colspan='3'>&nbsp;<input type='text' size='40' name='con_agnt_email' value='<%//=client.getCon_agnt_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'></td>
          <td class='title'>이동전화</td>
          <td>&nbsp;
              <input type='text' size='15' name='con_agnt_m_tel' value='<%//=client.getCon_agnt_m_tel()%>' maxlength='15' class='text'></td>
          </tr>
      </table></td>
    </tr>	
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
      	<tr><td class=line2 style='height:1'></td></tr>
        <tr>
          <td width='10%' class='title'>매출</td>
          <td width='90%'>&nbsp;
		      <input type="radio" name="car_use" value="1" checked>
              대여사업매출&nbsp;
              <input type="radio" name="car_use" value="2" >
              리스사업매출&nbsp;
			  </td>
          </tr>
      </table></td>
    </tr>				
    <tr>
      <td colspan="2">* 매출을 어떤것으로 할지 정해야 합니다.</td>
    </tr>	
    <tr>
      <td colspan="2">* -(부)금액으로 발행할 경우 비고란에 (9999-99-99 당초 세금계산서 일자)를 넣어주세요. : 수정세금계산서 공급가변경으로 등록이 됩니다. 변경해야 하는 경우 전산팀에 문의하세요.</td>
    </tr>	
    <tr>
      <td colspan="2" align="right"><a href="javascript:tax_reg();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>	</td>
    </tr>		
  </table>
<script language="JavaScript">
<!--
//-->
</script>  
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>