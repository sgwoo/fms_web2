<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.car_office.*, acar.user_mng.*, acar.cont.*, card.*,acar.common.*"%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
		
		
	CarOffPreBean bean = new CarOffPreBean();
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
		
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
	
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
					"&seq="+seq+"";
		
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정
	function update(){
		var fm = document.form1;
		
		var con_amt 		= toInt(parseDigit(fm.con_amt.value));
		if(con_amt > 0){
			if(fm.trf_st0.value == '')			{ alert('계약금 지급수단을 선택하십시오.'); 	fm.trf_st0.focus(); 		return; }
			if(fm.trf_st0.value == '1'){
				if(fm.con_bank.value == '') 	{ alert('계약금 지급금융사를 입력하십시오.'); 	fm.con_bank.focus(); 		return; }
				if(fm.con_acc_no.value == '') 	{ alert('계약금 계좌번호를 입력하십시오.'); 	fm.con_acc_no.focus(); 		return; }
				if(fm.con_acc_nm.value == '') 	{ alert('계약금 계좌예금주를 입력하십시오.'); 	fm.con_acc_nm.focus(); 		return; }
			}	
			if(fm.con_est_dt.value == '') 	{ alert('계약금 지급예정일을 입력하십시오.'); 	fm.con_est_dt.focus(); 		return; }
		}		
		
		if(confirm('등록 하시겠습니까?')){	
			fm.action='pur_pre_i_a.jsp';	
			fm.target='i_no';		
			fm.submit();
		}	
	}	
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="seq" 	value="<%=seq%>">
  <input type='hidden' name="mode" 		value="<%=mode%>">
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>계출관리 > <span class=style5>사전계약 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=13% class=title>출고영업소</td>
                    <td width=17%>&nbsp;
                    	<input type='text' size='15' name='car_off_nm' maxlength='20' class='default' value='<%=bean.getCar_off_nm()%>'>                    	
                    </td>
                    <td width=10% class=title>계출번호</td>
                    <td width=20%>&nbsp;
                    	<input type='text' size='20' name='com_con_no' maxlength='20' class='default' value='<%=bean.getCom_con_no()%>'>
                    </td>                    
                    <td width=10% class=title>요청일시</td>
                    <td width=30%>&nbsp;
                    	<input type='text' size='20' name='req_dt' maxlength='40' class='default' value='<%=AddUtil.ChangeDate2(AddUtil.getDate(4))%> <%=AddUtil.getTimeHMS()%>'>
                    </td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
      	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보 수정</span> 
      	</td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                 <tr> 
                    <td width=13% class=title>자체영업여부</td>
                    <td colspan="3">&nbsp;
                    	<input type="checkbox" name="bus_self_yn" value="Y" <%if (bean.getBus_self_yn().equals("Y")){%>checked<%}%>> 자체영업
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>Q코드</td>
                    <td colspan="3">&nbsp;
                    	<input type="checkbox" name="q_reg_dt" value="Y" <%if (!bean.getQ_reg_dt().equals("")){%>checked<%}%>> 4시간 동안은 자체영업 고객만 예약 가능
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>에이전트노출여부</td>
                    <td colspan="3">&nbsp;
                    	<input type="checkbox" name="agent_view_yn" value="Y" <%if (bean.getAgent_view_yn().equals("Y")){%>checked<%}%>> 에이전트에 차량 보이기
                    </td>
                </tr>
                                     
                <tr> 
                    <td width=13% class=title>차명</td>
                    <td colspan="3">&nbsp;
                    	<input type='text' size='100' name='car_nm' class='default' value='<%=bean.getCar_nm()%>'>
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>선택품목</td>
                    <td colspan="3" >&nbsp;
                    	<textarea rows='3' cols='100' name='opt'><%=bean.getOpt()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>외장색상</td>
                    <td colspan="3" >&nbsp;
                    	<input type='text' size='100' name='colo' class='default' value='<%=bean.getColo()%>'>
                    </td>
                </tr> 
                <tr> 
                    <td width=13% class=title>내장색상</td>
                    <td colspan="3" >&nbsp;
                    	<input type='text' size='100' name='in_col' class='default' value='<%=bean.getIn_col()%>'>
                    </td>
                </tr>   
                <tr> 
                    <td width=13% class=title>가니쉬색상</td>
                    <td colspan="3" >&nbsp;
                    	<input type='text' size='100' name='garnish_col' class='default' value='<%=bean.getGarnish_col()%>'>
                    </td>
                </tr>                                
                <tr> 
                    <td width=13% class=title>엔진</td>
                    <td colspan="3">&nbsp;
                    	<select name="eco_yn">
                    		<option value="" <%if (bean.getEco_yn().equals("")){%>selected<%}%>>미입력</option>
                    		<option value="0"<%if (bean.getEco_yn().equals("0")){%>selected<%}%>>가솔린엔진</option>
                    		<option value="1"<%if (bean.getEco_yn().equals("1")){%>selected<%}%>>디젤엔진</option>
                    		<option value="2"<%if (bean.getEco_yn().equals("2")){%>selected<%}%>>LPG엔진</option>
                    		<option value="3"<%if (bean.getEco_yn().equals("3")){%>selected<%}%>>하이브리드</option>
                    		<option value="4"<%if (bean.getEco_yn().equals("4")){%>selected<%}%>>플러그인 하이브리드</option>
                    		<option value="5"<%if (bean.getEco_yn().equals("5")){%>selected<%}%>>전기차</option>
                    		<option value="6"<%if (bean.getEco_yn().equals("6")){%>selected<%}%>>수소차</option>
                    	</select>
                    </td>
                </tr>                                
                <tr>
                  	<td width=10% class=title>소비자가</td>
                  	<td width="37%">&nbsp;
                  		<input type='text' name='car_amt' size='10' value='<%=AddUtil.parseDecimal(bean.getCar_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>원
                  	</td>
                  	<td width=10% class=title>출고예정일</td>
                  	<td>&nbsp;
                  		<input type='text' size='11' name='dlv_est_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(bean.getDlv_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  	</td>
                </tr>	
                <tr>
                  	<td class=title>계약금</td>
                  	<td colspan='3'>&nbsp;
                  	    금액 : 
                  		<input type='text' name='con_amt' size='10' value='<%=AddUtil.parseDecimal(bean.getCon_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>원
                  		&nbsp;
                  		지급수단 :                  		
                     <select name="trf_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="3" <%if(bean.getTrf_st0().equals("3")) out.println("selected");%>>카드</option>
        				<option value="1" <%if(bean.getTrf_st0().equals("1")) out.println("selected");%>>현금</option>        				
        			  </select>
        			  <br> 
        			  &nbsp;
                      카드/금융사 : 
					  <select name='con_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(bean.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                        <%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>' <%if(bean.getCon_bank().equals(String.valueOf(ht.get("CARD_KIND")))) out.println("selected");%>><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
                    </select>
				  	&nbsp;
					카드/계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=bean.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					적요/예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=bean.getCon_acc_nm()%>' size='20' class='text'>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(bean.getCon_est_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  	</td>
                </tr>	
                <tr>
                  	<td class=title>계약금지급일</td>
                  	<td colspan='3'>&nbsp;
                  		<input type='text' size='11' name='con_pay_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(bean.getCon_pay_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  	</td>
                </tr>
                <tr> 
                    <td width=13% class=title>비고</td>
                    <td colspan="3" >&nbsp;
                    	<textarea rows='3' cols='100' name='etc'><%=bean.getEtc()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	      <td align='center'>	 
        	     
        		<a href="javascript:update()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	        
        		&nbsp;&nbsp;&nbsp;&nbsp;
        		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	      </td>
    </tr>
</table>
</form>
<script language="JavaScript">
<!--	
	
	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

