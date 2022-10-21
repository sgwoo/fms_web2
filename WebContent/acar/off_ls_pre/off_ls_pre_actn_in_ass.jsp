<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.common.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String id = request.getParameter("id")==null?"":request.getParameter("id");//client_id
	
	ClientBean client = al_db.getClient(id);
	

	Vector tels = olpD.getTels(id);
	
	apprsl = olpD.getPre_apprsl(car_mng_id);
	int km = AddUtil.parseInt(apprsl.getAss_ed_km()) - AddUtil.parseInt(apprsl.getAss_st_km());
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComBean[] insCom = c_db.getInsComAll();
	
	//사원전체리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function ass_y(){
	var fm = document.form1;
	var chk = fm.ass_chk.options[fm.ass_chk.selectedIndex].value;
	if(chk == "Y"){
		
	}else{
		fm.ass_st_km.value = "";
		fm.ass_ed_km.value = "";
		fm.ass_st_dt.value = "";
		fm.ass_ed_dt.value = "";
		fm.ass_wrt.value = "";
	}
}
function updApprsl_ass(ioru){
	var fm = document.form1;
	var ass_st_dt = ChangeDate2(fm.ass_st_dt.value);
	var ass_ed_dt = ChangeDate2(fm.ass_ed_dt.value);
	var chk = fm.ass_chk.options[fm.ass_chk.selectedIndex].value;
	if(chk == "Y"){
		if(ass_st_dt != "" && ass_ed_dt != ""){
			if(ioru=="i"){
				if(!confirm('등록 하시겠습니까?')){ return; }
			}else if(ioru=="u"){
				if(!confirm('수정 하시겠습니까?')){ return; }
			}
			fm.gubun.value = ioru;
			fm.target = "i_no";
			fm.action = "/acar/off_ls_pre/off_ls_pre_updApprsl_ass.jsp";
			fm.submit();
		}else{
			if(ass_st_dt==""){ alert("보증시작일을 입력해 주세요!"); }
			if(ass_ed_dt==""){ alert("보증만료일을 입력해 주세요!"); }
			return;
		}
	}else{
		if(ioru=="i"){
			if(!confirm('등록 하시겠습니까?')){ return; }
		}else if(ioru=="u"){
			if(!confirm('수정 하시겠습니까?')){ return; }
		}
		fm.gubun.value = ioru;
		fm.target = "i_no";
		fm.action = "/acar/off_ls_pre/off_ls_pre_updApprsl_ass.jsp";
		fm.submit();
	}
}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body>
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="id" value="<%=client.getClient_id()%>">
<input type="hidden" name="flag" value="no_open">
<input type="hidden" name="gubun" value="">
  <table border="0" cellspacing="0" cellpadding="0" width="400">
    <tr> 
      <td width="120"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증서</span> <select name='ass_chk' onChange="javascript:ass_y()">
          <option value='Y' <%if(apprsl.getAss_chk().equals("Y")){%>selected<%}%>>있음</option>
          <option value='N' <%if(!apprsl.getAss_chk().equals("Y")){%>selected<%}%>>없음</option>
        </select> 
        
      </td>
      <td  id="td_input" width="280" ><%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        <%if(olpD.getApprsl_ass(car_mng_id)){%>
        <a href='javascript:updApprsl_ass("i");'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        <%}else{%>
        <a href='javascript:updApprsl_ass("u");'><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
        <%}%>
        <%}%></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
      <td id="td_content" colspan="2" class="line" > <table border="0" cellspacing="1" cellpadding="0"  width="400">
          <tr> 
            <td class='title' align="center" width="100">보증KM</td>
            <td  width="280"> &nbsp; <input class="num" type="text" name="ass_st_km" size="10" value="<%=AddUtil.parseDecimal(apprsl.getAss_st_km())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
              ~ 
              <input class="num" type="text" name="ass_ed_km" size="10" value="<%=AddUtil.parseDecimal(apprsl.getAss_ed_km())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
              <% if(!apprsl.getAss_st_dt().equals("") && !apprsl.getAss_ed_dt().equals("")){ %>(<%= AddUtil.parseDecimal(km) %>)KM <% } %></td>
          </tr>
          <tr> 
            <td class='title' align="center" width="100">보증기간</td>
            <td  width="280"> &nbsp; <input class="text" type="text" name="ass_st_dt" size="11" value="<%=AddUtil.ChangeDate2(apprsl.getAss_st_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
              ~ 
              <input class="text" type="text" name="ass_ed_dt" size="11" value="<%=AddUtil.ChangeDate2(apprsl.getAss_ed_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
              <% if(!apprsl.getAss_st_dt().equals("") && !apprsl.getAss_ed_dt().equals("")){ %>(<%= AddUtil.gapDate(apprsl.getAss_st_dt(), apprsl.getAss_ed_dt()) %>)일 <% } %></td>
          </tr>
          <tr> 
            <td class='title' width="100">작성자</td>
            <td  width="280"> &nbsp; <select name="ass_wrt">
                <option value='' <%if(apprsl.getAss_wrt().equals("")){%>selected<%}%>>선택</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(apprsl.getAss_wrt().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%		}
					}%>
              </select></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
</body>
<script language='javascript'>
<!--
ass_y();
-->
</script>
</html>
