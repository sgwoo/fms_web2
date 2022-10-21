<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.car_sche.*" %>
<%@ page import="acar.free_time.*,acar.common.*, acar.doc_settle.*" %>
<%@ page import="acar.schedule.*,acar.user_mng.*" %>

<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//연차취소 신청의뢰자
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	
	String st_dt = request.getParameter("st_dt")==null?"d":request.getParameter("st_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	
	
	String doc_no = request.getParameter("doc_no")==null?"":request.getParameter("doc_no");	
	
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	String start_date = request.getParameter("start_date")==null?"":request.getParameter("start_date");
	String end_date = request.getParameter("end_date")==null?"":request.getParameter("end_date");
	
	
	//해당부서 사원리스트
	LoginBean login = LoginBean.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	String dept_id = c_db.getUserDept(user_id);
	
	Vector vt = ft_db.Free_per(user_id, doc_no);
	int vt_size = vt.size();
	Vector vt2 = ft_db.Free_CancelList(user_id, doc_no);
	int vt2_size = vt2.size();
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleOver_time("22", doc_no);  //doc_no는  free_time의 doc_no doc_settle에서는 doc_id임
	
	String  login_id = request.getParameter("login_id")==null?"":request.getParameter("login_id");  //로그인 id

	login_id = ck_acar_id;
	
%>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--

function free_close()
{
	var theForm = opener.document.form1;
	theForm.submit();
	self.close();
	window.close();
}

function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}



// 최종결재
function cm_gj()
{
	var theForm = document.form1;
	theForm.cmd.value="c";
	
	if(confirm('연차취소를 결재하시겠습니까?')){	
			theForm.action='free_time_cancel_a.jsp';		
			theForm.target='i_no';
			theForm.submit();
	}						
}


function s_cm_check()
{
	var theForm = document.form1;
	
	theForm.cmd.value="s_cm";
			
	if(confirm('메세지 재전송 하시겠습니까?')){	
			theForm.action='free_time_cancel_a.jsp';		
			theForm.target='i_no';
			theForm.submit();
	}						
}



//결재안된건 강제정리
function cm_check1()
{
	var theForm = document.form1;

	theForm.cmd.value="c";
		
	if(confirm('결재하시겠습니까?')){			
		theForm.action='free_time_cancel_a1.jsp';			
		theForm.target='i_no';
		theForm.submit();
	}						
}		

//-->
</script>
</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>휴가신청 취소 결재 </span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./free_time_cancel_a.jsp" name='form1' method='post' enctype="">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="doc_no" value="<%=doc_no%>">

	<input type="hidden" name="cmd" value="">
<%if(vt2_size > 0){
		for(int i = 0 ; i < vt2_size ; i++){
			Hashtable ht = (Hashtable)vt2.elementAt(i); %>		
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	 <tr> 
                  <td class='title' width="15%">신청자</td>
                  <td width="34%">&nbsp;&nbsp;<%=ht.get("USER_NM")%></td>
                  <td class='title' width="17%">등록된일자</td>
                  <td width="34%">&nbsp;&nbsp;<%=ht.get("START_DATE")%> ~ <%=ht.get("END_DATE")%></td>
                </tr>
                <tr> 
                    <td class='title'>제목</td>
                    <td COLSPAN="3">&nbsp;&nbsp;<%=ht.get("CANCEL_TIT")%></td>
                </tr>		  
                <tr> 
                    <td class='title'>내용</td>
                    <td COLSPAN="3">&nbsp;&nbsp;<textarea name='content' rows='9' cols='70' readonly><%=ht.get("CANCEL_CMT")%></textarea> </td>
                </tr>
            </table>
		</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    
    <tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="12%" rowspan="2" class="title">결재</td>
					<td width="28%" align="center" class="title">담당자</td>
					<td width="26%" align="center" class="title">지점장/팀장</td>
					<td align="center" class="title"></td>					
				</tr>
				<tr>
				  <td align="center"><%= ht.get("USER_NM") %></td>
				  				  
			      <td align="center"><%=c_db.getNameById(doc.getUser_id2(),"USER")%><br><%=doc.getUser_dt2()%>
        			  <%if( doc.getUser_dt2().equals("")  && !doc.getUser_id2().equals("XXXXXX")  ){
        			  		String user_id2 = doc.getUser_id2();
        					        			
        			 %>
        			  <%	if(user_id2.equals(login_id) || nm_db.getWorkAuthUser("전산팀",login_id) ){%>
        			    <a href="javascript:cm_gj()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        		  </td>  
			      
			      <td align="center">&nbsp;<% if (ck_acar_id.equals("000063")) {%>
			      <a href='javascript:s_cm_check()' onMouseOver="window.status=''; return true">메세지재전송 </a> &nbsp;
			      <a href='javascript:cm_check1()' onMouseOver="window.status=''; return true">연차정리 </a>
			       <% } %></td>
			  </tr>
			</table>
		</td>
	</tr>	
	   
	
<input type="hidden" name="start_date" value="<%=ht.get("START_DATE")%>">
<input type="hidden" name="end_date" value="<%=ht.get("END_DATE")%>">

<%}
}%>
	<tr>
	<td align=right>
		<a href="javascript:free_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
	</td>
	</tr>
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
