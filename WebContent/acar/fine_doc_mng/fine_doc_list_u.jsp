<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String doc_id 		= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq_no 		= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//과태료리스트
	FineDocListBn 	= FineDocDb.getFineDocList(doc_id, car_mng_id, seq_no);
	FineDocBn 		= FineDocDb.getFineDoc(doc_id);
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//수정하기
	function fine_update(){
		var fm = document.form1;
		
		if(!confirm('수정하시겠습니까?'))
			return;	
		
		fm.cmd.value = "i";
		fm.target = "i_no";
		fm.action = "fine_doc_list_u_a.jsp";
		fm.submit();
	}	
	
	//삭제하기
	function fine_delete(){
		var fm = document.form1;
		
		if(!confirm('삭제하시겠습니까?'))
			return;	
		
		if(!confirm('정말 삭제하시겠습니까?'))
			return;	

		fm.cmd.value = "d";
		fm.target = "i_no";
		fm.action = "fine_doc_list_u_a.jsp";
		fm.submit();
	}
	
	//수신처-참조 수정하기(20190814)
	function fine_update2(){
		var fm = document.form1;
		
		if(!confirm('수정하시겠습니까?'))
			return;	
		
		fm.cmd.value = "u_fine_doc";
		fm.target = "i_no";
		fm.action = "fine_doc_list_u_a.jsp";
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='seq_no' value='<%=seq_no%>'>
<input type='hidden' name='cmd' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > <span class=style5>이의신청공문 리스트 수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h colspan="2"></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class="line" colspan="2">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title'>고지서번호</td>
                    <td class='title'>차량번호</td>	
                    <td class='title'>상호/성명</td>
                    <td class='title'>생년월일</td>
                    <td class='title'>운전면허번호</td>
                    <td class='title'>사업자등록번호</td>
                    <td class='title'>임대기간</td>
                </tr>
                <tr align="center"> 
                    <td><input type="text" name="paid_no" size="25" class="text" value="<%=FineDocListBn.getPaid_no()%>"></td>
                    <td><input type="text" name="car_no" size="12" class="text" value="<%=FineDocListBn.getCar_no()%>"></td>
                    <td><input type="text" name="firm_nm" size="30" class="text" value="<%=FineDocListBn.getFirm_nm()%>"></td>
                    <td><input type="text" name="ssn" size="15" class="text" value="<%=FineDocListBn.getSsn()%>"></td>
                    <td><input type="text" name="lic_no" size="15" class="text" value="<%=FineDocListBn.getLic_no()%>"></td>
                    <td><input type="text" name="enp_no" size="15" class="text" value="<%=FineDocListBn.getEnp_no()%>"></td>
                    <td><input type="text" name="rent_start_dt" size="12" class="text" value="<%=FineDocListBn.getRent_start_dt()%>">
                    	 ~ <input type="text" name="rent_end_dt" size="12" class="text" value="<%=FineDocListBn.getRent_end_dt()%>"></td>
                </tr>
            </table>
        </td> 
    </tr>
    <tr>
    	<td>※ 과태료공문 표지에 운전면허번호를 빈값으로 입력 하시려면 [ 0 ](숫자)을 입력하세요.(나머지는 미입력시 빈값으로 표시)</td>    
        <td align="right">
		  <%if(nm_db.getWorkAuthUser("과태료관리자",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
	  	 	  <a href="javascript:fine_update();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a>&nbsp;
	  	 	  <a href="javascript:fine_delete();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif"  align="absmiddle" border="0"></a>&nbsp;
		  <%}%>
		 </td>
    </tr>	
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% style="margin-top: 20px;">
    <tr> 
        <td class="line" colspan="2">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="18%">수신처 - 참조</td>
                    <td class='title' width="*"></td>
                </tr>
                <tr align="center"> 
                    <td><input type="text" name="mng_dept" size="25" class="text" value="<%=FineDocBn.getMng_dept()%>"></td>
                    <td></td>
                </tr>
            </table>
        </td> 
    </tr>
    <tr> 
    	<td>※ 수신처 - 참조 수정은 해당건의 과태료이의신청공문 표지만 수정됩니다. (청구기관관리 메뉴에 등록된 청구기관의 '참조'는 수정되지 않습니다.)</td>
        <td align="right">
		  <%if(nm_db.getWorkAuthUser("과태료관리자",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
	  	 	  <a href="javascript:fine_update2();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a>&nbsp;
		  <%}%>
		 </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
