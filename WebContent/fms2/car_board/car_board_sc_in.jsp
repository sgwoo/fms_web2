<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_board.*, acar.user_mng.*"%>
<jsp:useBean id="cb_db" scope="page" class="acar.car_board.CarBoardDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector memos = new Vector();
	int memo_size = 0;
	
	memos = cb_db.getCarBoardList(car_mng_id, "");
	memo_size = memos.size();
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function memo_delete(car_mng_id, seq){
		var fm = document.form1;
				
		fm.m_seq.value 		= seq;
		
		if(confirm('삭제하시겠습니까?')){	
			if(confirm('진짜로 삭제하시겠습니까?')){			
				fm.action='car_board_memo_d_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}									
		}									
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
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='m_seq' >
<input type='hidden' name='from_page' value='car_board'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
<%	if(memo_size > 0){
		for(int i = 0 ; i < memo_size ; i++){
			CarBoardBean memo = (CarBoardBean)memos.elementAt(i);%>
	            <tr>
        		    <td width='14%' align='center'>
        		      <%if(memo.getGubun().equals("MA")){%>검사<%}%>
        			  <%if(memo.getGubun().equals("AC")){%>사고<%}%>
        			  <%if(memo.getGubun().equals("ET")){%>기타<%}%>
        		    </td>
        		    <td width='12%' align='center'><%=memo.getRent_l_cd()%></td>
        		    <td width='10%' align='center'><%=c_db.getNameById(memo.getReg_id(), "USER")%></td>
        		    <td width='10%' align='center'><%=memo.getReg_dt()%></td>        		
        		    <td width='54%'>
		                <table>
            			    <tr>
            				    <td><%=Util.htmlBR(memo.getContent())%>
								<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
								&nbsp;&nbsp;<a href="javascript:memo_delete('<%=memo.getCar_mng_id()%>','<%=memo.getSeq()%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_delete.gif"  align="absmiddle" border="0"></a>
								<%}%>
								</td>
            			    </tr>
			            </table>
		            </td>
		         
		        </tr>
<%		}
	}else{%>
		        <tr>
		            <td colspan='7' align='center'>등록된 데이타가 없습니다 </td>
		        </tr>
<%	}%>
	        </table>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>
