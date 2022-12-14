<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.partner.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String mail_yn = request.getParameter("mail_yn")==null?"":request.getParameter("mail_yn");
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "35", "01", "");
	
	Vector vt = se_dt.getServ_offList_ddj(s_kd, t_wd, gubun1, gubun2, sort_gubun, sort, "1", br_id, mail_yn);
	int vt_size = vt.size();
	
	
	int vc_size =0;
	
	String newyn = "";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript">
<!--
//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}
	
	//선택메일 보내기 
	function SendMail2(kd){
		
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
	
		if(cnt < 2){
		   	alert("최소 2곳이상 선택하세요.");
		   return;
		}
			
		window.open('about:blank', "SendMail", "left=0, top=0, width=650, height=550, scrollbars=yes, status=yes, resizable=yes");
		alert("선택하신 금융기관에만 보냅니다.");
		if(!confirm('메일을 발송 하시겠습니까?')){	return; }
		fm.target = "SendMail";
		fm.action = "mail_fin_m.jsp?gubun1="+ kd+"&cnt="+cnt;
	   fm.submit();	
	 	
	}
	
	//리스트 엑셀 전환
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "popup_fin_man_ddj_excel.jsp";
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="sort_gubun" value="<%=sort_gubun%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="mail_yn" value="<%= mail_yn %>">
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<%if(gubun1.equals("0001")){%>		
		<input type="button" class="button" value="메일발송" onclick="SendMail2('ddj')"/>
		<% } %>
		&nbsp;<input type="button" class="button" value="검색결과 엑셀저장" onclick="pop_excel();"/>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr> 
					<td width='5%' class='title'>연번<%if(gubun1.equals("0001")){%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"><%}%></td>
					<td width='5%' class='title'>관리구분</td>
					<td width='15%' class='title'>상호</td>
					<td width='5%' class='title'>성명</td>
					<td width='15%' class='title'>부서</td>
					<td width='7%' class='title'>직책</td>
					<td width='7%' class='title'>직통전화번호</td>
					<td width='7%' class='title'>휴대폰</td>
					<td width='15%' class='title'>E-MAIL</td>
					<td width='5%' class='title'>담당업무</td>
					<td width="7%" class='title'>최초등록일</td>
					<td width="7%" class='title'>변경등록일</td>
				</tr>
			</table>
		</td>
	</tr>
<%if(vt_size !=0 ){%>
	<tr>            
		<td class=line> 
			<table border="0" cellspacing="1" cellpadding="0" width=100% >
              <% for(int i=0; i< vt_size; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
				<tr> 
					<td width='5%' align='center'><%=i+1%><%if(gubun1.equals("0001")){%><input type="checkbox" name="ch_cd" value="<%=ht.get("EMP_NM")%>^<%=ht.get("EMP_EMAIL")%>"><%}%></td>
					<td width='5%' align='center'><%=ht.get("NM_CD")%></td>
					<td width='15%' align='center'><%=ht.get("OFF_NM")%></td>
					<td width='5%' align='center'><%=ht.get("EMP_NM")%></td>
					<td width='15%' align='center'><%=ht.get("DEPT_NM")%></td>
					<td width='7%' align='center'><%=ht.get("EMP_POS")%></td>
					<td width='7%' align='center'><%=ht.get("EMP_HTEL")%></td>
					<td width='7%' align='center'><%=ht.get("EMP_MTEL")%></td>
					<td width='15%' align='center'><%=ht.get("EMP_EMAIL")%></td>
					<td width='5%' align='center'><%=ht.get("EMP_ROLE")%></td>
					<td width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
					<td width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UPT_DT")))%></td>
				</tr>
			  <%}%>
			</table>
		</td>
	</tr>
<%}else{%>
	<tr>	        
		<td class='line'> 
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr> 
					<td align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 업체가 없습니다.</td>
				</tr>          
			</table>
		</td>
	</tr>
<%}%>

</table>		
</form>
</body>
</html>
