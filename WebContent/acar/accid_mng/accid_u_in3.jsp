<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.accid.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"3":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(){
		var fm = document.form1;	
		if(fm.accid_id.value == ''){ alert("상단을 먼저 등록하십시오."); return; }		
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.target = "i_no"
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=800>
  <form action="accid_u_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
    <tr> 
      <td>< 보험사 ></td>
      <td align="right"> 
        <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
        <%	}%>
      </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" width=100%>
          <tr> 
            <td class=title rowspan="3" width="40">당<br>
              사<br>
              차<br>
              량</td>
            <td class=title width=80>보험사명</td>
            <td width=170> 
              <input type="text" name="our_ins" value="<%=a_bean.getOur_ins()%>" size="20" class=text maxlength="20" >
            </td>
            <td class=title width=80>보험접수NO</td>
            <td width="170"> 
              <input type="text" name="our_num" value="<%=a_bean.getOur_num()%>" size="20" class=text maxlength="15" >
            </td>
            <td class=title width="80">피해발생</td>
            <td> 
              <select name="our_dam_st">
                <option value=""  <%if(a_bean.getOur_dam_st().equals("")){%> selected<%}%>>없음</option>
                <option value="1" <%if(a_bean.getOur_dam_st().equals("1")){%>selected<%}%>>대인</option>
                <option value="2" <%if(a_bean.getOur_dam_st().equals("2")){%>selected<%}%>>대물</option>
                <option value="3" <%if(a_bean.getOur_dam_st().equals("3")){%>selected<%}%>>대인+대물</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td class=title>대물담당자명</td>
            <td> 
              <input type="text" name="my_nm" value="<%=a_bean.getMy_nm()%>" size="15" class=text maxlength="10">
            </td>
            <td class=title>연락처</td>
            <td colspan="3"> 
              <input type="text" name="my_tel" value="<%=a_bean.getMy_tel()%>" size="15" class=text maxlength="15" >
            </td>
          </tr>
          <tr> 
            <td class=title>대인담당자명</td>
            <td> 
              <input type="text" name="one_nm" value="<%=a_bean.getOne_nm()%>" size="15" class=text maxlength="10">
            </td>
            <td class=title>연락처</td>
            <td colspan="3"> 
              <input type="text" name="one_tel" value="<%=a_bean.getOne_tel()%>" size="15" class=text maxlength="15" >
            </td>
          </tr>
        </table>
      </td>
    </tr>
	<%if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("2") || a_bean.getAccid_st().equals("3")){//피해,가해,쌍방%>	
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" width=100%>
          <tr> 
            <td class=title rowspan="3" width="40">상<br>
              대<br>
              차<br>
              량</td>
            <td class=title width=80>보험사명</td>
            <td width=170> 
              <input type="text" name="ot_ins" value="<%=a_bean.getOt_ins()%>" size="20" class=text maxlength="20" >
            </td>
            <td class=title width=80>보험접수NO</td>
            <td width="170"> 
              <input type="text" name="ot_num" value="<%=a_bean.getOt_num()%>" size="20" class=text maxlength="15" >
            </td>
            <td class=title width="80">피해발생</td>
            <td> 
              <select name="ot_dam_st">
                <option value=""  <%if(a_bean.getOur_dam_st().equals("")){%>  selected<%}%>>없음</option>
                <option value="1" <%if(a_bean.getOur_dam_st().equals("1")){%> selected<%}%>>대인</option>
                <option value="2" <%if(a_bean.getOur_dam_st().equals("2")){%> selected<%}%>>대물</option>
                <option value="3" <%if(a_bean.getOur_dam_st().equals("3")){%> selected<%}%>>대인+대물</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td class=title>대물담당자명</td>
            <td> 
              <input type="text" name="mat_nm" value="<%=a_bean.getMat_nm()%>" size="15" class=text maxlength="10" >
            </td>
            <td class=title>연락처</td>
            <td colspan="3"> 
              <input type="text" name="mat_tel" value="<%=a_bean.getMat_tel()%>" size="15" class=text maxlength="15" >
            </td>
          </tr>
          <tr> 
            <td class=title>대인담당자명</td>
            <td> 
              <input type="text" name="hum_nm" value="<%=a_bean.getHum_nm()%>" size="15" class=text maxlength="10">
            </td>
            <td class=title>연락처</td>
            <td colspan="3"> 
              <input type="text" name="hum_tel" value="<%=a_bean.getHum_tel()%>" size="15" class=text maxlength="15" >
            </td>
          </tr>
        </table>
      </td>
    </tr>
	<%}%>	
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
