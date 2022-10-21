<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.user_mng.*, acar.cooperation.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//마지막대여정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, r_st);
	
	
	String title = "[미제출서류]"+l_cd+" "+r_st+" "+client.getFirm_nm();
	String sub_id = "";
	
	sub_id = fee.getExt_agnt();
	
	if(sub_id.equals(""))	sub_id = base.getBus_id();
	
	
	//미결제서류관련 업무협조 등록리스트
	Vector vt = cp_db.CooperationContChkMList(l_cd);
	int vt_size = vt.size();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;

		if(fm.sub_id.value == '')		{	alert('업무담당자가 없습니다.'); 											return; }
		if(fm.content.value == '')		{	alert('내용을 입력하십시오'); 					fm.content.focus(); 		return; }
				
		if(confirm('등록하시겠습니까?'))
		{							
			fm.action = 'lc_n_memo_a.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
  	}
	
	function view_content(seq, in_dt, in_id)
	{
		window.open("/fms2/cooperation/cooperation_u.jsp?mode=view&seq="+seq+"&in_dt="+in_dt+"&in_id="+in_id, "COOPERATION_C", "left=100, top=100, width=700, height=600");
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body>

<form action='' method="post" name='form1'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='m_id' 		value='<%=m_id%>'>
  <input type='hidden' name='l_cd' 		value='<%=l_cd%>'>
  <input type='hidden' name='r_st' 		value='<%=r_st%>'>
  <input type='hidden' name='title' 	value='<%=title%>'>  
  <input type='hidden' name='sub_id' 	value='<%=sub_id%>'>    
<table border=0 cellspacing=0 cellpadding=0 width=650>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 영업지원 > <span class=style5>계약점검 미제출서류 고지</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr><td class=line2></td></tr>	
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
				<tr>
					<td class='title' width="100">업무담당자</td>
					<td width="570">&nbsp;<%=c_db.getNameById(sub_id,"USER")%></td>
				</tr>
				<tr>
					<td class='title'>제목</td>
					<td>&nbsp;<%=title%></td>
				</tr>
				<tr>
					<td class='title'>내용</td>
					<td>&nbsp;<textarea rows='15' name='content' cols='80' maxlength='2000' style='IME-MODE: active'></textarea></td>
				</tr>
			</table>
		</td>
	</tr>	
    <tr>
        <td class=h></td>
    </tr> 	
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>	
	<tr>
	    <td align="right">
      		<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>			
	    </td>
	</tr>	
    <%}%>	
<%	if(vt.size()>0){%>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td width='30' class='title'> 연번 </td>
					<td width='70' class='title'> 요청일자 </td>
					<td width='400' class='title'> 내용 </td>
					<td width='80' class='title'> 처리일자 </td>					
					<td width='70' class='title'> 처리담당자 </td>
				</tr>
<% 		for(int i=0; i< vt.size(); i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
					<td align='center'><%=(i+1)%></td>
					<td align='center'><%= AddUtil.ChangeDate2((String)ht.get("IN_DT")) %></td>
					<td>&nbsp;<a href="javascript:view_content('<%=ht.get("SEQ")%>', '<%=ht.get("IN_DT")%>','<%=ht.get("IN_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CONTENT")%></a></td>
					<td align='center'><table width=100% border=0 cellspacing=0 cellpadding=5><tr><td align=center><%if(ht.get("OUT_DT").equals("")){%>미처리<%}else{%><%=ht.get("OUT_DT")%><%}%></td></tr></table></td>
					<td align='center'><%=ht.get("SUB_NM")%></td>					
				</tr>

<%		}%>
            </table>
        </td>
    </tr>		
<%	}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
