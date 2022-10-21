<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.accid.*"%>
<jsp:useBean id="oa_bean" class="acar.accid.OneAccidBean" scope="page"/>
<jsp:useBean id="ot_bean" class="acar.accid.OtAccidBean" scope="page"/>
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
	String mode = request.getParameter("mode")==null?"5":request.getParameter("mode");
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
	
	//자기신체사고
	OneAccidBean oa_r [] = as_db.getOneAccid(c_id, accid_id);
	
	//상대차량 인적사항
	OtAccidBean ot_r [] = as_db.getOtAccid(c_id, accid_id);
	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(cmd, idx){
		var fm = document.form1;
		fm.idx2.value = idx;
		fm.cmd.value = cmd;
		if(fm.accid_id.value == ''){ alert("상단을 먼저 등록하십시오."); return; }		
		if(cmd == 'u'){
			if(!confirm('수정하시겠습니까?')){	return;	}
		}else{
			if(!confirm('등록하시겠습니까?')){	return;	}		
		}
		fm.action = "accid_u_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
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
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='size' value='<%=oa_r.length%>'>
    <input type='hidden' name='idx2' value=''>	
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>인적 사고</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>번호</td>
                    <td class=title colspan="2">구분</td>
                    <td class=title>성명</td>
                    <td class=title>성별</td>
                    <td class=title>연령</td>
                    <td class=title>관계</td>
                    <td class=title>연락처</td>
                    <td class=title>병원명</td>
                    <td class=title>연락처(병원)</td>
                    <td class=title>부상정도(진단)</td>
                    <td class=title>처리</td>
                </tr>
          <%for(int i=0; i<oa_r.length; i++){
    			oa_bean = oa_r[i];%>
                <tr id='tr_one_accid' style="display:''"> 
                    <td align="center"> 
                      <input type="text" name="seq_no" value="<%=oa_bean.getSeq_no()%>" size="1" class=whitetext>
                    </td>
                    <td align="center"> 
                      <select name="o_accid_st">
                        <option value="1" <%if(oa_bean.getOne_accid_st().equals("1")){%> selected<%}%>>자손</option>
        				<%if(ot_r.length==0){%>
                        <option value="2" <%if(oa_bean.getOne_accid_st().equals("2")){%> selected<%}%>>대인</option>				
        				<%	}%>				
        				<%	for(int j=0; j<ot_r.length; j++){
        						ot_bean = ot_r[j];%>	
                        <option value="<%=j+2%>" <%if(oa_bean.getOne_accid_st().equals(Integer.toString(j+2))){%> selected<%}%>>대인<%=ot_bean.getSeq_no()%></option>
        				<%	}%>
                      </select>
                    </td>
                    <td align="center"> 
                      <select name="o_wound_st">
                        <option value="1" <%if(oa_bean.getWound_st().equals("1")){%> selected<%}%>>경상</option>
                        <option value="2" <%if(oa_bean.getWound_st().equals("2")){%> selected<%}%>>중상</option>
                        <option value="3" <%if(oa_bean.getWound_st().equals("3")){%> selected<%}%>>사망</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_nm" value="<%=oa_bean.getNm()%>" size="8" class=text maxlength="10">
                    </td>
                    <td align="center"> 
                      <select name="o_sex">
                        <option value="1" <%if(oa_bean.getSex().equals("1")){%> selected<%}%>>남</option>
                        <option value="2" <%if(oa_bean.getSex().equals("2")){%> selected<%}%>>여</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_age" value="<%=oa_bean.getAge()%>" size="2" class=text maxlength="3" >
                      세</td>
                    <td align="center"> 
                      <input type="text" name="o_relation" value="<%=oa_bean.getRelation()%>" size="8" class=text maxlength="5">
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_tel" value="<%=oa_bean.getTel()%>" size="12" class=text maxlength="15">
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_hosp" value="<%=oa_bean.getHosp()%>" size="13" class=text maxlength="15">
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_hosp_tel" value="<%=oa_bean.getHosp_tel()%>" size="12" class=text maxlength="15">
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_diagnosis" value="<%=oa_bean.getDiagnosis()%>" size="17" class=text maxlength="10">
                    </td>
                    <td align="center">
        			<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        			<a href="javascript:save('u', '<%=i%>')"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a>
        			<%	}%>
        			</td>
                </tr>
          <%	}%>
                <tr> 
                    <td align="center" colspan="12">&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">-<input type="text" name="seq_no" value="" size="1" class=whitetext></td>
                    <td align="center"> 
                      <select name="o_accid_st">
                        <option value="1">자손</option>
        				<%	for(int j=0; j<ot_r.length; j++){
        						ot_bean = ot_r[j];%>	
                        <option value="<%=j+2%>">대인<%=ot_bean.getSeq_no()%></option>
        				<%	}%>						
                      </select>
                    </td>
                    <td align="center"> 
                      <select name="o_wound_st">
                        <option value="1">경상</option>
                        <option value="2">중상</option>
                        <option value="3">사망</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_nm" size="8" class=text maxlength="10">
                    </td>
                    <td align="center"> 
                      <select name="o_sex">
                        <option value="1" selected>남</option>
                        <option value="2">여</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_age" size="2" class=text maxlength="3" >
                      세</td>
                    <td align="center"> 
                      <input type="text" name="o_relation" size="8" class=text maxlength="5">
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_tel" size="12" class=text maxlength="15">
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_hosp" size="13" class=text maxlength="15">
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_hosp_tel" size="12" class=text maxlength="15">
                    </td>
                    <td align="center"> 
                      <input type="text" name="o_diagnosis" size="17" class=text maxlength="10">
                    </td>
                    <td align="center">
        			<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        			<a href="javascript:save('i', '')"><img src="/acar/images/center/button_in_reg.gif" align="absmiddle" border="0"></a>
        			<%	}%>
        			</td>
                </tr>
            </table>
        </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
