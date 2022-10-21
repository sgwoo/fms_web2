<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"10":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"1":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	String from_page = "/fms2/forfeit_mng/forfeit_r_frame.jsp";
	
	if(user_id.equals("")){
		user_id=login.getCookieValue(request, "acar_id");
	}
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	String proxy_dt =Util.getDate();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//리스트 팩스보내기 
	function FineInFax(){
	
		var fm = i_no.document.form1;	
		
		var newWin = window.open("", "pop", "left=100, top=100, width=800, height=800, scrollbars=auto");
		var proxy_dt = document.form1.proxy_dt.value;
		fm.target = "pop";
		fm.action = "forfeit_proxy_fax_a.jsp?from_page=<%=from_page%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&proxy_dt="+proxy_dt;
		fm.submit();		
			
	}

	


	//과태료 청구메일  보기
	function view_mail(m_id, l_cd, c_id, seq_no, dem_dt){			
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;

		fm.action="/mailing/rent/email_fine_bill_sn2.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&seq_no="+seq_no;		
		
		fm.target="_blank";
		fm.submit();
	}	
	
	
	//스케쥴등록
	function FineInReg(){
	
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
			
		if(cnt == 0){
		 	alert("과태료를 선택하세요.");
			return;
		}	

		//FineInMail(); //이메일까지 자동전송.
		
		var newWin = window.open("", "pop", "left=700, top=200, width=400, height=200, scrollbars=no");
				
		fm.target = "pop";
		fm.action = "forfeit_proxy_i.jsp?gubun=1";
		fm.submit();		
		
	}

	//메일발송 - 청구전 발송
	function FineInMail(){
	
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
			
		if(cnt == 0){
		 	alert("선납 과태료를 선택하세요.");
			return;
		}	
		
		<%if(gubun4.equals("6")){%>
		if(!confirm('경찰서 일괄등록한 납부자변경 과태료 안내 메일을 발송하겠습니까?')){	return;	}
		fm.action = "forfeit_nbc_polic_mail_a.jsp";
		<%}else{%>
		if(!confirm('선납 과태료 메일을 발행하시겠습니까?')){	return;	}
		fm.action = "forfeit_sn_mail_a.jsp";
		<%}%>
		fm.target = "ii_no";
		fm.submit();
			
	}
	
	
	
	//통화 메모 보기
	function view_memo(m_id, l_cd, c_id, tm_st, accid_id, serv_id, mng_id){
		var auth_rw = document.form1.auth_rw.value;
		window.open("/acar/con_ins_m/ins_memo_frame_s.jsp?auth_rw="+auth_rw+"&tm_st="+tm_st+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&serv_id="+serv_id+"&mng_id="+mng_id, "INS_MEMO", "left=100, top=100, width=700, height=450");
	}	
	
	//과태금 세부내용 보기
	function view_forfeit(m_id, l_cd, c_id, seq_no){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.seq_no.value = seq_no;
		fm.target = "d_content";
//		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.action = "/acar/fine_mng/fine_mng_frame.jsp";		
		fm.submit();
	}
	
	//고객 보기
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}
	
	//엑셀 
	function pop_excel(){
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("엑셀로 출력할 계약을 선택하세요.");
			return;
		}	
		fm.target = "_blak";
		fm.action = "popup_excel.jsp";
		fm.submit();
	}		

	//등록
	function reg_forfeit(){
		var fm = document.form1;
		fm.target = "d_content";
//		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.action = "/acar/fine_mng/fine_mng_frame.jsp";		
		fm.submit();
	}
	
	//수금관리 이동
	function forfeit_in(){
		var fm = document.form1;
		fm.gubun2.value = '6';
		fm.target = "d_content";
		fm.action = "/acar/con_forfeit/forfeit_frame_s.jsp";
		fm.submit();
	}	
	//현황
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
		document.form1.action="forfeit_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}

function ChangeDT()
{
	document.form1.proxy_dt.value = ChangeDate(document.form1.proxy_dt.value);
}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='serv_id' value=''>
<input type='hidden' name='seq_no' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='out'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

<% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
  <tr> 
	
	
	
    <td align="right" > <!--<img src=/acar/images/center/arrow_jci.gif border=0 align=absmiddle>&nbsp;<input type='text' size='15' name='proxy_dt' class='text' value='<%=proxy_dt%>' >
	<a href="javascript:FineInFax();"><img src=/acar/images/center/button_stbh.gif border=0 align=absmiddle></a>-->&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="javascript:FineInReg();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <%//if(user_id.equals("000096")){%> <a href="javascript:FineInMail();"><img src=/acar/images/center/button_bh.gif border=0 align=absmiddle></a> <%//}%>

    </td>
   </tr>
<%	}%> 


    <tr>
	    <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
        		<tr>
        		    <td width=100%>
        			    <table border="0" cellspacing="0" cellpadding="0" width=100%>
        			        <tr>
        				        <td align='center'>
        				        <iframe src="/fms2/forfeit_mng/forfeit_r_sc_in.jsp?from_page=<%=from_page%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
        				        </td>
        			        </tr>
        			    </table>
        		    </td>
        		</tr>
	        </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="ii_no" width="0" height="0" frameborder="0" noresize>
</body>
</html>
