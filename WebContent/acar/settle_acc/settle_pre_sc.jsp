<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"8":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	
	//로그인ID
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 5; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function view_memo(m_id, l_cd)
	{
		var auth_rw = document.form1.auth_rw.value;		
//		window.open("memo_frame_s.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd, "MEMO", "left=100, top=100, width=800, height=600");
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
	}
	
	//정산 세부내용 보기
	function view_settle(mode, m_id, l_cd, client_id, c_id, gubun3){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;		
		fm.client_id.value = client_id;
		fm.target = "d_content";		
		if(mode=='cont' && l_cd.length == 6){
			fm.mode.value = "client";
		}else{
			fm.mode.value = mode;				
		}

		if(gubun3 == '업무대여'){			
			fm.action = "/acar/settle_acc/settle_c3.jsp";		
			return;
		}else{
			fm.action = "/acar/settle_acc/settle_c.jsp";					
			fm.submit();
		}
	}

	//중도해지정산  보기
	function view_settle_doc(m_id, l_cd){
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
	}	

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='today' value='<%=today%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	<td>
      <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
				<td align='center'>
				  <iframe src="/acar/settle_acc/settle_pre_sc_in.jsp?auth_rw=<%=auth_rw%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height - 10%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
				  </iframe>
				</td>
		</tr>
	  </table>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr>      		
    <td class='line'> 
        <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td colspan="2" class='title' align="center">합계</td>
            <td colspan="2" class='title' align="center">선수금</td>
            <td colspan="2" class='title' align="center">대여료</td>
            <td colspan="2" class='title' align="center">과태료</td>
            <td colspan="2" class='title' align="center">면책금</td>
            <td colspan="2" class='title' align="center">휴/대차료</td>
            <td colspan="2" class='title' align="center">중도해지위약금</td>
            <td colspan="2" class='title' align="center">단기요금</td>			
          </tr>
          <tr align="center"> 
            <td class='title'>건수</td>
            <td class='title'>금액</td>
            <td class='title'>건수</td>
            <td class='title'>금액</td>
            <td class='title'>건수</td>
            <td class='title'>금액</td>
            <td class='title'>건수</td>
            <td class='title'>금액</td>
            <td class='title'>건수</td>
            <td class='title'>금액</td>
            <td class='title'>건수</td>
            <td class='title'>금액</td>
            <td class='title'>건수</td>
            <td class='title'>금액</td>
            <td class='title'>건수</td>
            <td class='title'>금액</td>
          </tr>
          <tr> 
            <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">건</td>
            <td align="right" class="is"><input type="text" name="amt" size="10" class="isnum2">원</td>
            <td align="right"><input type="text" name="cnt" size="1" class="whitenum2">건</td>
            <td align="right"><input type="text" name="amt" size="8" class="whitenum2">원</td>
            <td align="right"><input type="text" name="cnt" size="2" class="whitenum2">건</td>
            <td align="right"><input type="text" name="amt" size="10" class="whitenum2">원</td>
            <td align="right"><input type="text" name="cnt" size="2" class="whitenum2">건</td>
            <td align="right"><input type="text" name="amt" size="7" class="whitenum2">원</td>
            <td align="right"><input type="text" name="cnt" size="2" class="whitenum2">건</td>
            <td align="right"><input type="text" name="amt" size="9" class="whitenum2">원</td>
            <td align="right"><input type="text" name="cnt" size="1" class="whitenum2">건</td>
            <td align="right"><input type="text" name="amt" size="8" class="whitenum2">원</td>
            <td align="right"><input type="text" name="cnt" size="2" class="whitenum2">건</td>
            <td align="right"><input type="text" name="amt" size="10" class="whitenum2">원</td>
            <td align="right"><input type="text" name="cnt" size="1" class="whitenum2">건</td>
            <td align="right"><input type="text" name="amt" size="8" class="whitenum2">원</td>
          </tr>
        </table>
    </td>
  </tr>	  
</table>
</form>
</body>
</html>
