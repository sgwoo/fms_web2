<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*,acar.common.*, acar.user_mng.*" %>
<%@ page import="acar.car_sche.*" %>
<%@ include file="/acar/cookies.jsp" %>

<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="ts_bean" class="acar.car_sche.TodayScheBean" scope="page"/>
<jsp:useBean id="ts2_bean" class="acar.car_sche.TodaySche2Bean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<%
	CarSchDatabase csd = CarSchDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
		
	String auth_rw = "";
	String start_year = "";
	String start_mon = "";
	String start_day = "";
	String acar_id = "";
	String user_id = "";
	String user_nm = "";
	int seq = 0;
	String title = "";
	String content = "";
	String reg_dt = "";
	String sch_kd = "";
	String sch_chk = "";
	String work_id = "";
	String cmd = "";
	
	if(request.getParameter("start_year")!=null) start_year=request.getParameter("start_year");
	if(request.getParameter("start_mon")!=null) start_mon=request.getParameter("start_mon");
	if(request.getParameter("start_day")!=null) start_day=request.getParameter("start_day");
	if(request.getParameter("acar_id")!=null) acar_id=request.getParameter("acar_id");
	if(request.getParameter("user_id")!=null) user_id=request.getParameter("user_id");
	if(request.getParameter("seq")!=null) seq=Util.parseInt(request.getParameter("seq"));
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("sch_chk")!=null) sch_chk=request.getParameter("sch_chk");
	
	if(seq!=0)
	{
		cs_bean = csd.getCarScheBean(user_id,seq,start_year,start_mon,start_day);
		user_id = cs_bean.getUser_id();
		user_nm = cs_bean.getUser_nm();
		seq = cs_bean.getSeq();
		start_year = cs_bean.getStart_year();
		start_mon = cs_bean.getStart_mon();
		start_day = cs_bean.getStart_day();
		title = cs_bean.getTitle();
		content = cs_bean.getContent();
		reg_dt = cs_bean.getReg_dt();
		sch_kd = cs_bean.getSch_kd();
		sch_chk = cs_bean.getSch_chk();
		work_id = cs_bean.getWork_id();
	}
	
	TodayScheBean[] tsbns = csd.getTodaySche(user_id,start_year+start_mon+start_day);
	
	TodaySche2Bean[] ts2bns = csd.getTodaySche2(user_id,start_year+start_mon+start_day);
	
	//해당부서 사원리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);	
%>
<HTML>
<HEAD>
<TITLE> FMS </TITLE>

<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='javascript'>
<!--
function ScheReg()
{
	var theForm = document.ScheRegForm;
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
		if(get_length(theForm.content.value) > 4000){
			alert("4000자 까지만 입력할 수 있습니다.");
			return;
		}	
	theForm.start_year.value = theForm.start_yr.value;
	theForm.start_mon.value = theForm.start_mth.value;
	theForm.start_day.value = theForm.start_day.value;
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	theForm.submit();
}
function ScheUp()
{
	var theForm = document.ScheRegForm;
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}
		if(get_length(theForm.content.value) > 4000){
			alert("4000자 까지만 입력할 수 있습니다.");
			return;
		}	
	theForm.start_year.value = theForm.start_yr.value;
	theForm.start_mon.value = theForm.start_mth.value;
	theForm.start_day.value = theForm.start_day.value;
	theForm.cmd.value = "u";
	theForm.target = "i_no";
	theForm.submit();
}
function ScheDel(){
	var theForm = document.ScheRegForm;
	if(!confirm('삭제하시겠습니까?'))
	{
		return;
	}
	theForm.start_year.value = theForm.start_yr.value;
	theForm.start_mon.value = theForm.start_mth.value;
	theForm.start_day.value = theForm.start_day.value;
	theForm.cmd.value = "d";
	theForm.target = "i_no";
	theForm.submit();
}
function LoadSche()
{
	var theForm = opener.document.form1;
	theForm.submit();
	self.close();
	window.close();
}
	function get_length(f) {
		var max_len = f.length;
		var len = 0;
		for(k=0;k<max_len;k++) {
			t = f.charAt(k);
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}
		return len;
	}	
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</HEAD>

<BODY>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 고객지원업무스케줄 > 스케줄등록 > <span class=style5>일정등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
	<form action="sch_null_ui.jsp" name='ScheRegForm' method='post'>
	<tr>
		<td align='right'>
<%
	if(seq!=0)
	{
%> <a href="javascript:ScheUp()"><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
        &nbsp; 
		<%if(acar_id.equals(user_id)){%>
        <a href="javascript:ScheDel()"><img src=../images/center/button_delete.gif align=absmiddle border=0></a> 
        &nbsp; 		
		<%}%>
<%
	}else{
%>
	 		<a href="javascript:ScheReg()"><img src=../images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
<%}%>
			<a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a> 
		</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr> 
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>			
				<input type="hidden" name="acar_id" value="<%=user_id%>">			
                <tr> 
                    <td class='title' width=20%>구분</td>
                    <td width=80%>&nbsp;<select name="sch_chk">
                        <option value="1" <%if(sch_chk.equals("1")) out.print("selected");%>>업무일지</option>
                        <option value="2" <%if(sch_chk.equals("2")) out.print("selected");%>>현지출근</option>
                        <%//if(user_bean.getLoan_st().equals("")){%>            					
                        <option value="0" <%if(sch_chk.equals("0")) out.print("selected");%>>재택근무</option>
                        <%//} %>
                      </select> </td>
                </tr>
                <tr> 
                    <td class='title'>제목</td>
                    <td>&nbsp;<input type='text' name='title' value="<%=title%>" size='70' MAXLENGTH='70' class=text></td>
                </tr>
				<!--
                <tr> 
                    <td class='title'>대체업무자</td>
                    <td align='left' > 
                      &nbsp;<select name="work_id">
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'  <%if(work_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
        			  &nbsp;(년차,휴가,병가,경조사일때 - 전자문서 결재 대체자)
                    </td>
                </tr>		  		  		  
				-->
                <tr> 
                    <td class='title'>일정</td>
                    <td>&nbsp;<input type='radio' name='sch_kd' value='1' <%if(sch_kd.equals("1")||sch_kd.equals("")) out.print("checked");%>>
                      개인&nbsp; <input type='radio' name='sch_kd' value='2' <%if(sch_kd.equals("2")) out.print("checked");%>>
                      공유&nbsp; </td>
                </tr>
                <tr> 
                    <td class='title'>일자</td>
                    <td>&nbsp;<script language="javascript">init2(5,<%=start_year%>,<%=start_mon%>,<%=start_day%>); init_display("start");</script></td>
                </tr>
                <tr> 
                    <td class='title'>내용</td>
                    <td><% if(user_id.equals("000010")||user_id.equals("000011")||user_id.equals("000012")
		||user_id.equals("000013")||user_id.equals("000025")||user_id.equals("000020")
		||user_id.equals("000026")||user_id.equals("000034")){ %><font style="{font: 8pt}">※차량정비 및 거래처방문은 업무등록하면 끝나고, 그외 기타 업무를 기재하세요.</font>
		<% } %>
		            &nbsp;<textarea name='content' rows='25' cols='72'><%=content%></textarea>
		            </td>
                </tr>
            </table>
			<input type="hidden" name="seq" value="<%=seq%>">
			<input type="hidden" name="start_year" value="<%=start_year%>">
			<input type="hidden" name="start_mon" value="<%=start_mon%>">
			<input type="hidden" name="start_day" value="<%=start_day%>">
			<input type="hidden" name="cmd" value="">
        </td>
    </tr>
	<tr>
	    <td></td>
	</tr>		
</form>
</table>
<iframe src="about:blank" name="i_no" width="50" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>

</BODY>
</HTML>
