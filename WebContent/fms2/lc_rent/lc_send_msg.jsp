<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String msg_st 		= request.getParameter("msg_st")==null?"":request.getParameter("msg_st");
	
	boolean flag3 = true;
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		
	//자동차기본정보
	cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;	
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//수정
	function update(){
		var fm = document.form1;
		
		<%if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){ %>
		var now = new Date();//현재시간
		var hour = now.getHours();
		if(fm.trf_st0.value == '3' && hour > 15){
			alert('카드는 당일 오후4시에 마감합니다. 오후4시 이후에는 내일 신청하세요'); return;
		}
		<%}%>
		
		if(fm.trf_st0.value == '')			{ alert('출고영업소-선수금 지급수단을 선택하십시오.'); 	fm.trf_st0.focus(); 		return; }
		
		if(fm.trf_st0.value == '1'){
			if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){
				alert('차량대금(계약금)를 지급할 계좌를 입력하십시오.'); return;
			}
		}
		
		if(fm.con_est_dt.value == '') 	{ alert('출고영업소-선수금 지급예정일을 입력하십시오.'); 	fm.con_est_dt.focus(); 		return; }
		
		if(confirm('수정하시겠습니까?')){
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
				
			fm.action='lc_send_msg_a.jsp';		
			fm.target='i_no';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}		
		
	}
//-->
</script>
</head>
<body>
<center>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name='msg_st'  		value='<%=msg_st%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>송금요청 문자 발송</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>계약번호</td>
                    <td width='40%'>&nbsp;<%=rent_l_cd%></td>
                    <td class='title' width='10%'>상호</td>
                    <td width='40%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>차명</td>
                    <td colspan='3'>&nbsp;<%=cm_bean.getCar_comp_nm()%> <%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
    <%if(msg_st.equals("con_amt_pay_req")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약금 송금요청</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<%				if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getTrf_st0().equals("") && pur.getCon_bank().indexOf("은행") == 0){
                		if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002") || emp2.getCar_comp_id().equals("0003")){
                			if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){
                				pur.setTrf_st0("3");
                			}else{
                   				pur.setTrf_st0("1");
                   			}	
                		}	
                	}
	if(pur.getTrf_amt5() > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_st5().equals("")){
		//20220916 현대총신대대리점만 우선 카드 디폴트 처리
			if(emp2.getCar_off_id().equals("00588")){
				pur.setTrf_st5("3");
			}else{
   				pur.setTrf_st5("1");
   			}	
	}
                %>		
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                <td>&nbsp;
                	금액 : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원	
                     &nbsp;
                     지급수단 :
                     <select name="trf_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>현금</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>카드</option>
        			  </select> 
                     &nbsp;
                    금융사 :
					<select name='con_bank' class='default'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
                    <br><br>
				  	&nbsp;
				  	계좌종류 :
				  	<select name="acc_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
        			<br><br>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        								  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;(계약금지급일:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <%}%>        			
        			
    			</td>															
              </tr>              
            </table>
        </td>
    </tr>
    <%	if(pur.getTrf_amt5() > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_amt_pay_req().equals("")){%>
    <tr>
        <td class=h></td>
    </tr>		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>임시운행보험료</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                <td class='title' width='10%'>임시운행보험료</td>
                <td width='10%'>&nbsp;<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>원
                </td>
                <td class='title' width='10%'>요청여부</td>	
                <td width='70%'>&nbsp;<input type="checkbox" name="trf_amt_send" value="Y" checked> 계약금과 같이 송금요청한다.
                </td>
              </tr>    
            </table>
        </td>
    </tr>
    <%	}%>
    <%}%>
    <tr>
        <td class=h></td>
    </tr>	
    <%if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){ %>
    <tr>
        <td><font color=red>※ 카드는 당일 오후4시에 마감합니다. 오후4시 이후에는 내일 신청하세요. </font></td>
    </tr>	
    <%}%>
    <tr>
	    <td align="right">
	    	<a id="submitLink" href='javascript:update()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    	&nbsp;&nbsp;
	    	<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
    	</td>
	<tr>		
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>