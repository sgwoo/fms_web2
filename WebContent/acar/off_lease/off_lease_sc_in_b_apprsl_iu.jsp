<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_yb.*"%>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	Offls_ybBean detail = olyD.getYb_detail(car_mng_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//상품평가 수정 등록 구분하기 위해
	String apprsl_car_mng_id = olyD.getApprsl_Car_mng_id(car_mng_id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function ChDate(arg)
{
	var ch_date = replaceString("-","",arg);

	if(ch_date!="")
	{
	if(ch_date.length!=8)
	{
		alert('날짜의 형식은 "2002-01-23" 또는 "200020123" 입니다.');
		return "";
	}
	ch_year = parseInt(ch_date.substring(0,4),10);
	ch_month = parseInt(ch_date.substring(4,6),10);
	ch_day = parseInt(ch_date.substring(6,8),10);
	if(isNaN(ch_date))
	{
		alert("숫자와 '-' 만이 입력가능합니다.");
		return "";
	}
	if(!(ch_month>0 && ch_month<13))
	{
		alert("월은 01 - 12 까지만 입력 가능합니다.");
		return "";
	}
	ck_day = getDaysInMonth(ch_year,ChangeNum(ch_month))
	if(ck_day<ch_day)
	{
		alert("일은 01 - " + ck_day + " 까지만 입력 가능합니다.");
		return "";
	}
		
	return ch_year + ""+ChangeNum(ch_month) + ChangeNum(ch_day);
	}else{
	return "";
	}
}
function apprslUpd(ioru)
{
	var fm = document.form1;	
	//var apprsl_dt = ChDate(fm.apprsl_dt.value);
	//if(apprsl_dt != ""){
	//	fm.apprsl_dt_s.value = apprsl_dt;
	//}else{
	//	alert("평가일자를 입력하세요!");
	//	return;
	//}
	if(ioru=="i"){
		if(!confirm('평가내용을 등록하시겠습니까?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('평가내용을 수정하시겠습니까?')){ return; }
	}
	fm.gubun.value = ioru;
	fm.action="./off_lease_apprsl_upd.jsp";
	fm.target = "i_no";
	fm.submit();
}
-->
</script>
</head>
<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>상품평가</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        <%if(apprsl_car_mng_id.equals("")){%>
        <a href='javascript:apprslUpd("i");'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        <%}else{%>
        <a href='javascript:apprslUpd("u");'><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
        <%}%>
        <%}%>
        <a href='javascript:history.go(-1);'><img src=../images/center/button_back_p.gif border=0 align=absmiddle></a> 
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td class='title' width=16%> 자체평가</td>
                    <td width=22%>&nbsp; <select name='apprsl_lev'>
                        <option value='0'>선택</option>
                        <option value='1' <%if(detail.getLev().equals("1")){%>selected<%}%>>상</option>
                        <option value='2' <%if(detail.getLev().equals("2")){%>selected<%}%>>중</option>
                        <option value='3' <%if(detail.getLev().equals("3")){%>selected<%}%>>하</option>
                      </select> </td>
                    <td class='title' width=14%>평가일자</td>
                    <td align="center" width=18%> <input  class="text" type="text" name="apprsl_dt" size="20" value="<%=AddUtil.ChangeDate2(detail.getApprsl_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                    <td class='title' width=13%>&nbsp;</td>
                    <td width=17%>&nbsp; </td>
                </tr>
                <tr> 
                    <td class='title'>평가요인</td>
                    <td colspan="5">&nbsp; <textarea  class="textarea" name="apprsl_reason" cols="142" rows="2"><%=detail.getReason()%></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>차량상태</td>
                    <td colspan="5">&nbsp; <input  class="text" type="text" name="apprsl_car_st" size="70" value="<%=detail.getCar_st()%>"> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>사고유무</td>
                    <td> &nbsp; 
                      <%if(detail.getAccident_yn().equals("1")){%>
                      &nbsp;있음 
                      <%}else{%>
                      &nbsp;없음 
                      <%}%>
                    </td>
                    <td class='title'>담당자</td>
                    <td>&nbsp; <select name="damdang_id">
                        <option value='' <%if(detail.getDamdang_id().equals("")){%>selected<%}%>>선택</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	
        %>
                        <option value='<%=user.get("USER_ID")%>' <%if(detail.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%
        						}
        					}		%>
                      </select> </td>
                    <td class='title'>최종수정자</td>
                    <td>&nbsp; 
                      <%if(login.getAcarName(detail.getModify_id()).equals("error")){%>
                      &nbsp; 
                      <%}else{%>
                      <%=login.getAcarName(detail.getModify_id())%> 
                      <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>반납전 차량운행자</span></td>
        <td align="right">&nbsp; </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" align='left' class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=16%> 운행자</td>
                    <td width=84% colspan="5">&nbsp; <select name='driver'>
                        <option value='0'>선택</option>
                        <option value='1' <%if(detail.getDriver().equals("1")){%>selected<%}%>>임원</option>
                        <option value='2' <%if(detail.getDriver().equals("2")){%>selected<%}%>>직원</option>
                      </select> </td>
                </tr>
            </table>
        </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
