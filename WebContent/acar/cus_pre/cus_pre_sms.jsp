<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.fee.*, acar.cont.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"1":request.getParameter("c_id");
	String car_no 	= request.getParameter("car_no")==null?"1":request.getParameter("car_no");	

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String destphone = "";

	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	LoginBean login = LoginBean.getInstance();
	String reg_id = login.getCookieValue(request, "acar_id");
	
	//로그인
	UsersBean user_bean2 = umd.getUsersBean(reg_id);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//고객관련자
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	
	
	//관리담당자
	UsersBean user_bean = umd.getUsersBean(base.getMng_id());
	
	if(base.getCar_st().equals("4")){
		user_bean = umd.getUsersBean(base.getMng_id2());
	}
	
	//외근직일 경우 본인이 발신자
	//if(!user_bean2.getLoan_st().equals("")){
	//	user_bean = user_bean2;
	//}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//SMS 발송내역(100일이내발송분)
	function viewSmsHistory(){
		var fm = document.form1;
		var SUBWIN="/fms2/con_fee/view_sms_history.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client.getClient_id()%>&firm_nm=<%=client.getFirm_nm()%>";	
		window.open(SUBWIN, "ViewSmsHis", "left=50, top=100, width=1000, height=800, scrollbars=yes, status=yes");
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<table border="0" cellspacing="0" cellpadding="0" width=750>
	<tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>담당자별업무추진현황 > <span class=style5>문자발송</span></span></td>	
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td colspan="2" class=h></td>
    </tr>		
    <tr>
	    <td>
		  <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>문자발송</span>
		  </td>
	    <td align='right'>
			  <a href="javascript:viewSmsHistory();" title='SMS 발송내역'>[SMS 발송내역]</a>
		  </td>		  
	</tr>
	<tr>
        <td colspan="2" class=line2></td>
    </tr>
	<tr>
		<td colspan="2" class='line' width=750>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="10%">수신</td>
                    <td width=90%>
        			 
        				<%for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        					if(mgr.getMgr_st().equals("차량이용자")){
							destphone = mgr.getMgr_m_tel()+""; %>
        				&nbsp;&nbsp;[<%=mgr.getMgr_st()%>]  <%=mgr.getMgr_nm()%> <%=mgr.getMgr_title()%>
        				<%}}%>	
        			  &nbsp;&nbsp;수신번호 : <input type='text' size='15' name='destphone' value='<%=destphone%>' maxlength='100' class='text'>	
					  <input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
					  <input type='hidden' name='car_no' value='<%=car_no%>'>
						
					</td>
			    </tr>
                <tr> 
                    <td class='title'>발신</td>
                    <td>
        			  &nbsp;&nbsp;발신번호 : <input type='text' size='15' name='sendphone' value='<%=user_bean.getUser_m_tel()%>' maxlength='100' class='text'>
        			  &nbsp;발신자명 : <input type='text' size='15' name='sendname' value='<%=user_bean.getUser_nm()%>' maxlength='100' class='text'> 
        			  &nbsp;</font>
					</td>
			    </tr>			
                <tr> 
                    <td class='title'>메세지</td>
                    <td>
        			  &nbsp;&nbsp;<textarea name='msg' rows='10' cols='72' class='text' onKeyUp="javascript:checklen()" style='IME-MODE: active' readOnly><%=client.getFirm_nm()%>고객님 안녕하십니까. 친절과 신뢰로 모시는 아마존카입니다. 

고객님이 이용중인 자동차(<%=car_no%>)검사 실시를 위해 당사 협력업체에서 고객님에게 연락드릴 예정입니다. 
고객님의 안전한 차량운행을 위해 협조 부탁드립니다. 감사합니다. 

(주)아마존카 www.amazoncar.co.kr </textarea>
        			 
					</td>
			    </tr>	
				 <tr> 
                    <td class='title'>예약일시</td>
                    <td colspan="4">
					  &nbsp;&nbsp;<input type="text" name="req_dt" size="12" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'>
					                                    <select name="req_dt_h">
                        									<%for(int i=0; i<24; i++){%>
                        									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        									<%}%>
                      									</select>
                      									<select name="req_dt_s">
                        									<%for(int i=0; i<59; i+=5){%>
                        									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        									<%}%>
                     									 </select>
                     									 <input type="hidden" name="msg_type" value="5"> 			  
														<input type='hidden' size='30' name='msg_subject' value='' maxlength='30' class='text' value="차량 검사 안내 문자">
					</td>
              


			    </tr>										
            </table>
		</td>
	</tr>	
	 
	<tr>
		<td colspan="2" align='right'> 
		  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		  <a href="javascript:SandSms()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		  <%}%>
		  <a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>			
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--

	//문자 보내기
	function SandSms(){
		var fm = document.form1;				
		if(confirm('문자를 보내시겠습니까?'))				
		{				
			
			fm.action = "/acar/cus_pre/cus_pre_sms_a.jsp";
			fm.target = "i_no";		
			fm.submit();	
		}
	}
//-->
</script>
</body>
</html>
