<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String	to_dt 	= AddUtil.getDate(1)+""+AddUtil.getDate(2)+""+AddUtil.getDate(3);		
	String  st_dt = "";
	String  std_dt = "";
	String  end_dt = "";
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		if(work_st == 'search1'){
			fm.action = 'sk_speedmate_excel.jsp';
		}else if(work_st == 'search2'){
			fm.action = 'sk_speedmate_excel_re.jsp';
		}else{
			return;
		}
		
		fm.work_st.value = work_st;
		fm.target = '_blank';
		fm.submit();
	}
	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > <span class=style5>SpeedMate제출자료</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
	    <td>&nbsp;</td>
    </tr>

    <tr>
	    <td><table width=100% border=0 cellspacing=1 cellpadding=0>
          <tr>
            <td width="200" rowspan="3" align="center" valign="middle"><img src=/acar/images/logo_1.png align=absmiddle border=0></td>
            <td><!-- <b>·</b> 전체관리 : 김진영과장  02-2000-0849  / 010-3825-3123  /  pdpost@sk.com  --></td>
          </tr>
          <tr>
            <!-- <td><b>·</b> 업무지원 : 장준우매니저 070-7800-0786 /  rosya37@sk.com</td> -->
            <td><b>·</b> 업무지원 : 한정수매니저 070-7800-0908 /  h956899@sk.com</td>
          </tr>
          <tr>
            <td><b></b></td>
    	  	</tr>
          <tr>
            <td align="center" valign="middle"><b>스피드메이트</b></td>
            <td>※ 하나은행 계좌 10099774681437 (SK네트웍스 스피드메이트) &nbsp;&nbsp;&nbsp; - 매달 월마감 후 5일내 입금바랍니다.</td>
          </tr>
        </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정비 관련리스트 조회</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td width=5% class=title style='height:30'>1</td> 
	                <td>&nbsp;
                	  <select name="s_kd">
						<option value="3" >전월</option>
                	  	<option value="1" >당월</option>
                		<option value="2" selected>기간</option>
                	  </select>&nbsp;&nbsp;
					  <input type='text' size='11' name='st_dt' class='text' value='<%=AddUtil.getDate(1)+""+AddUtil.getDate(2)+"01"%>'>
                      ~ 
            		  <input type='text' size='11' name='end_dt' class='text' value='<%=Util.getDate()%>'>
					 &nbsp;&nbsp;&nbsp;담당자 표시된 엑셀파일 열기 &nbsp;<a href="javascript:save('search2')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a> 
	                </td>
	            </tr>

	        </table>
	    </td>
    </tr>
	
    <tr>
	    <td>&nbsp;</td>
    </tr>

    <tr>
	    <td>※ 당월을 선택하고 [조회]버튼 클릭하면 현재 월에 신규 등록된 차량만 조회가 되고, <br>&nbsp;&nbsp;&nbsp;기간을 선택하고 날짜를 입력하고 [조회]버튼 클릭하면 입력한 기간에 해당하는 차량만 조회가 된다.</td>
    </tr>
	
    <tr>
	    <td>※ 담당자 표시 엑셀파일은 차량관리담당자의 이름과 연락처가 리스트에 같이 표시되어 있는 형태로 기존에 제공하던 리스트 형태입니다. </td>
    </tr>

    <tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
	
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비내역 등록</span></td>
    </tr>
	<tr>
		
		<td colspan="2">&nbsp;&nbsp;&nbsp;스피드메이트 정비내역 엑셀로 등록 :

            		<a href="javascript:var win=window.open('excel.jsp?user_id=<%=user_id%>','popup','left=10, top=10, width=800, height=600, status=no, scrollbars=no, resizable=no');"><img src=/acar/images/center/button_reg_excel.gif align=absmiddle border=0></a>&nbsp;

        </td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>
		<tr>
	    <td>&nbsp;</td>
    </tr>
	
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>품목등록</span></td>
    </tr>
	<tr>
		
		<td colspan="2">&nbsp;&nbsp;&nbsp;스피드메이트 정비품목 엑셀로 등록 :

            		<a href="javascript:var win=window.open('jb_excel.jsp?user_id=<%=user_id%>','popup','left=10, top=10, width=800, height=600, status=no, scrollbars=no, resizable=no');"><img src=/acar/images/center/button_reg_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
        </td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
