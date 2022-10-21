<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
		
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String gubun1		= request.getParameter("gubun1")==null?"9":request.getParameter("gubun1");
	String minus		= request.getParameter("minus")==null?"":request.getParameter("minus");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-200;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?minus="+minus+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&dt="+dt+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
//리스트 엑셀 전환
	function prop_excel(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "s_money_excel.jsp";
		fm.submit();
	}
	
	function prop_excel1(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "s_money_excel1.jsp";
		fm.submit();
	}
	
	//세부리스트
	function sub_list_pop(s_user_id){
		var fm = document.form1;	
		fm.s_user_id.value = s_user_id;			
		fm.target = '_blank';			
		fm.action = 's_money_sc_in_pop.jsp';					
		fm.submit();
	}

function save()	{
		var SUBWIN="./mtel_scan_i.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";	
		window.open(SUBWIN, "save", "left=100, top=50, width=650, height=400, scrollbars=yes");
	}	
	
	//수정하기
	function upd_car(seq, gubun, id, file){
	var SUBWIN="mtel_scan_upd.jsp?seq="+seq+"&gubun="+gubun+"&id="+id+"&file="+file;	
		window.open(SUBWIN, "upd_car", "left=100, top=50, width=630, height=400, scrollbars=yes");
	}
	
		//삭제하기
	function del_scanfile(file){
		var fm = document.form1;

		if(!confirm("해당내용을 삭제하시겠습니까?"))	return;		
		fm.scanfile_nm.value 	= file;		

		fm.target = "i_no";
		fm.action = "./mtel_scan_del.jsp";
		fm.submit();
	}
//-->
</script>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'> 
<input type='hidden' name='dt' value='<%=dt%>'> 
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'> 
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'> 
<input type='hidden' name='s_user_id' value=''> 
<input type='hidden' name='minus' value='<%=minus%>'> 
<input type='hidden' name='scanfile_nm' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    
        <td align='left'>
		<a href='javascript:save()'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>
    <tr>
		<td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td>
                        <iframe src="mtel_scan_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
					</td>
				</tr>
			</table>
		</td>
    </tr>
</table>

</form>
</body>
</html>
