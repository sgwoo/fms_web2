<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String msg_st = request.getParameter("msg_st")==null?"":request.getParameter("msg_st");
	
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	
	if(c_id.equals("")) c_id = rc_bean.getCar_mng_id();

	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	//연장계약
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();	
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(s_cd, "4");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<html>
<head>

<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;
		if(fm.s_cd.value == ''){ 	alert('s_cd가 없습니다. 확인하십시오.'); return; }
		if(fm.user_id.value == ''){ alert('user_id가 없습니다. 확인하십시오.'); return; }
		if(!confirm('등록하시겠습니까?')){	return; }					
		fm.target = "i_no";
		fm.action = "res_memo_null_ui.jsp";
		fm.submit();
	}
	
	function open_smsgate(firm_nm, m_tel){
		var fm = document.form1;
		var values 	= '&user_id='+fm.user_id.value+'&rent_l_cd=<%=s_cd%>&client_id=<%=rc_bean.getCust_id()%>&firm_nm='+firm_nm+'&m_tel='+m_tel;			
		var SUBWIN="/acar/sms_gate/sms_gate.jsp?auth_rw=6"+values;	
		window.open(SUBWIN, "pop", "left=300, top=150, width=900, height=900, menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
	}
	
	function user_msg(m_title, m_content, bus_id)
	{
		window.open("/acar/memo/memo_send_mini.jsp?send_id=<%=ck_acar_id%>&m_title="+m_title+"&m_content="+m_content+"&rece_id="+bus_id, "MEMO_SEND", "left=100, top=100, width=520, height=470, resizable=yes, scrollbars=yes, status=yes");
	}
	
	
//-->
</script>
</head>
<body leftmargin="15">
<form name="form1" method="POST" >
 <input type="hidden" name="user_id" value="<%=user_id%>">
 <input type="hidden" name="s_cd" value="<%=s_cd%>">
 <input type="hidden" name="c_id" value="<%=c_id%>"> 
 <input type="hidden" name="msg_st" value="<%=msg_st%>">
 <input type="hidden" name="cmd" value="">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 재무회계 > 요금관리 > <span class=style5>통화내역</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=h></td></tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>    	
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='16%' class='title'>계약구분</td>
                    <td width="28%"><font color="#3366CC"> <b> 
                        <%if(rent_st.equals("1")){%>
                        &nbsp;단기대여 
                        <%}else if(rent_st.equals("2")){%>
                        &nbsp;정비대차 
                        <%}else if(rent_st.equals("3")){%>
                        &nbsp;사고대차 
                        <%}else if(rent_st.equals("4")){%>
                        &nbsp;업무대여 
                        <%}else if(rent_st.equals("5")){%>
                        &nbsp;업무지원 
                        <%}else if(rent_st.equals("6")){%>
                        &nbsp;차량정비 
                        <%}else if(rent_st.equals("7")){%>
                        &nbsp;차량점검 
                        <%}else if(rent_st.equals("8")){%>
                        &nbsp;사고수리
                        <%}else if(rent_st.equals("9")){%>
                        &nbsp;보험대차
                        <%}else if(rent_st.equals("12")){%>
                        &nbsp;월렌트
                        <%}%>
                        </b></font> 
                    </td>
                    <td width='15%' class='title'>계약번호</td>
                    <td width="41%">&nbsp;<%=rc_bean.getRent_s_cd()%></td>
                </tr>
                <tr> 
                    <td class='title'>성명</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class='title'>상호</td>
                    <td>&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>전화번호</td>
                    <td>&nbsp;<%=rm_bean4.getTel()%></td>
                    <td class='title'>휴대폰</td>
                    <td>&nbsp;<%=rm_bean4.getEtc()%>
                        <a href="javascript:open_smsgate('<%=rc_bean2.getCust_nm()%>', '<%=rm_bean4.getEtc()%>')" title='<%=rc_bean2.getCust_nm()%>:<%=rm_bean4.getEtc()%> SMS발송 페이지로 이동하기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a>
                    </td>
                </tr>
                <%if(!rm_bean2.getTel().equals("")){%>
                <tr> 
                    <td class='title'>비상연락처</td>
                    <td colspan='3'>&nbsp;<%=rm_bean2.getMgr_nm()%>&nbsp;<%=rm_bean2.getTel()%>
                        <a href="javascript:open_smsgate('<%=rm_bean2.getMgr_nm()%>', '<%=rm_bean2.getTel()%>')" title='<%=rm_bean2.getMgr_nm()%>:<%=rm_bean2.getTel()%> SMS발송 페이지로 이동하기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a>
                    </td>                    
                </tr>     
                <%}%>
                <%if(!rm_bean1.getTel().equals("")){%>
                <tr> 
                    <td class='title'>추가운전자</td>
                    <td colspan='3'>&nbsp;<%=rm_bean1.getMgr_nm()%>&nbsp;<%=rm_bean1.getTel()%>
                        <a href="javascript:open_smsgate('<%=rm_bean1.getMgr_nm()%>', '<%=rm_bean1.getTel()%>')" title='<%=rm_bean1.getMgr_nm()%>:<%=rm_bean1.getTel()%> SMS발송 페이지로 이동하기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a>
                    </td>
                </tr>                               
                <%}%>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<font color="#000099"><b><%=reserv.get("CAR_NO")%></b></font></td>
                    <td class='title'>차명</td>
                    <td><table width=100% border=0 cellspacing=0 cellpadding=5><tr><td><%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td></tr></table></td>
                </tr>
                <tr> 
                    <td class='title'>약정대여기간</td>
                    <td colspan="3">&nbsp; 
                    	<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>~<%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%> &nbsp;&nbsp;
                    	(<%=rc_bean.getRent_months()%>개월<%=rc_bean.getRent_days()%>일)</td>
                </tr>
                <%
    			if(ext_size > 0){
    				for(int i = 0 ; i < ext_size ; i++){
    					Hashtable ext = (Hashtable)exts.elementAt(i);%>	
    					
                <tr> 
                    <td class=title>연장 [<%=ext.get("SEQ")%>]</td>
                    <td colspan="3">&nbsp;                         
                        <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_END_DT")))%> &nbsp;&nbsp;                    	
                        (<%=ext.get("RENT_MONTHS")%>개월<%=ext.get("RENT_DAYS")%>일) &nbsp;&nbsp;
                        | 계약일자 : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_DT")))%> &nbsp;&nbsp;
                    </td>
                </tr>
    		  <%		
    		  		}
    		  	}%>                  
                <tr> 
                    <td class='title'>배차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class='title'>반차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(), "USER")%>
                      <a href="javascript:user_msg('아마존카 월렌트', '월렌트 <%=rc_bean2.getFirm_nm()%> <%=reserv.get("CAR_NO")%> - ', '<%=rc_bean.getBus_id()%>')" onMouseOver="window.status=''; return true" title='관리담당자에게 통보하기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a>
                    </td>
                    <td class='title'>관리담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getMng_id(), "USER")%>
                      <a href="javascript:user_msg('아마존카 월렌트', '월렌트 <%=rc_bean2.getFirm_nm()%> <%=reserv.get("CAR_NO")%> - ', '<%=rc_bean.getMng_id()%>')" onMouseOver="window.status=''; return true" title='관리담당자에게 통보하기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
    	<td>&nbsp;</td>
    </tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
			        <td class=line2></td>
			    </tr>
				<tr>					
                    <td class='line'> 
                        <table  border=0 cellspacing=1 cellpadding="0" width=100%>
                            <tr> 
                                <td class=title width=10%>구분</td>
                                <td class=title width=16%>날짜</td>
                                <td class=title width=13%>작성자</td>
                                <td class=title width=13%>통화자</td>
                                <td class=title width=48%>통화내용</td>
                            </tr>
                        </table>        					
                    </td>        					
                    <td width=16>&nbsp;</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
		<td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td colspan=2><iframe src="./res_memo_i_in.jsp?msg_st=<%=msg_st%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&user_id=<%=user_id%>" name="i_in" width="100%" height="200" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>    
    <tr>
    	<td></td>
    </tr>
    <tr>
    	<td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%if(msg_st.equals("ret_msg")){ %>
                <tr>                    
                    <td class=title width=16%>반차알림</td>                            
                    <td>&nbsp;                       
                      <input type="hidden" name="sub" value="반차알림">
                    </td>
                </tr>
                <tr>                    
                    <td class=title>내용</td>                    
                    <td>&nbsp; 
                    <textarea name="note" cols=67 rows=5></textarea></td>
                </tr>                                
                <%}else{%>
                <tr>                    
                    <td class=title width=16%>통화자</td>                            
                    <td>&nbsp; 
                      <input type="text" name="sub" size="20" class=text>
                    </td>
                </tr>
                <tr>                    
                    <td class=title>통화내용</td>                    
                    <td>&nbsp; 
                    <textarea name="note" cols=67 rows=5></textarea></td>
                </tr>                
                <%}%>

           </table>
        </td>
    </tr>
    <tr>    	
        <td align="right"><a href="javascript:save()"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;<a href="javascript:self.close()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>