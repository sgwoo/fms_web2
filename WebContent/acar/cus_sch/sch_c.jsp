<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_sche.*,acar.common.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%
	CarSchDatabase csd = CarSchDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
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
	
	acar_id = login.getCookieValue(request, "acar_id");
	if(request.getParameter("start_year")!=null) start_year=request.getParameter("start_year");
	if(request.getParameter("start_mon")!=null) start_mon=request.getParameter("start_mon");
	if(request.getParameter("start_day")!=null) start_day=request.getParameter("start_day");
	if(request.getParameter("acar_id")!=null) user_id=request.getParameter("acar_id");
	if(request.getParameter("seq")!=null) seq=Util.parseInt(request.getParameter("seq"));
	
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
	
	//해당부서 사원리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	
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
function ScheUpDisp()
{
	var theForm = document.ScheDispForm;
	theForm.start_year.value = theForm.start_yr.value;
	theForm.start_mon.value = theForm.start_mth.value;
	theForm.start_day.value = theForm.start_day.value;
	theForm.submit();
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
	<form action="./sch_i.jsp?cmd=u" name='ScheDispForm' method='post'>
	<tr>
		<td align='right' width=100%>
<%
	if( (acar_id.equals(user_id) && (!sch_chk.equals("3") && !sch_chk.equals("4"))) || (nm_db.getWorkAuthUser("전산팀",acar_id) && (sch_chk.equals("3") || sch_chk.equals("4")) ))
	{
%>
		<a href="javascript:ScheUpDisp()"><img src=../images/center/button_modify_s.gif align=absmiddle border=0></a>&nbsp;
<%}%> 
		<a href="javascript:self.close();window.close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a> 
		</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
			    <tr>
			        <td width=20% class='title'>성명</td>					
                    <td width=80% align=left>&nbsp;<%=user_nm%></td>
			    </tr>				
			    <tr>					
                    <td class='title'>구분</td>
					<td align=left>
					&nbsp;<select name="sch_chk" disabled>
					<option value="1" <%if(sch_chk.equals("1")) out.print("selected");%>>업무일지</option>
					<option value="2" <%if(sch_chk.equals("2")) out.print("selected");%>>현지출근</option>
					<%//if(user_bean.getLoan_st().equals("")){%>    
					<option value="0" <%if(sch_chk.equals("0")) out.print("selected");%>>재택근무</option>
					<%//} %>					
					</select>
              &nbsp;</td>
			    </tr>
			    <tr>
			        <td class='title'>대체업무자</td>					
                    <td align=left>&nbsp;<%=c_db.getNameById(work_id,"USER")%>
				    &nbsp;(년차,휴가,병가,경조사일때 - 전자문서 결재 대체자)</td>
			    </tr>								
				<tr>
					<td class='title'>제목</td>					
                    <td align=left>&nbsp;<%=title%>
                    <input type='hidden' name='title' value="" ></td>
				</tr>
				<tr>
					<td class='title'>일정</td>
					<td>
						&nbsp;<input type='radio' name='sch_kd' value='1' <%if(sch_kd.equals("1")) out.print("checked");%> disabled>개인&nbsp;
						<input type='radio' name='sch_kd' value='2' <%if(sch_kd.equals("2")) out.print("checked");%> disabled>공유&nbsp;
					</td>
				</tr>
				<tr>
					<td class='title'>일자</td>
					<td>&nbsp;<script language="javascript">init2(5,<%=start_year%>,<%=start_mon%>,<%=start_day%>); init_display("start");</script></td>
				</tr>
				<tr>
					<td class='title'>내용</td>
					<td><% if(user_id.equals("000010")||user_id.equals("000011")||user_id.equals("000012")
		||user_id.equals("000013")||user_id.equals("000025")||user_id.equals("000020")
		||user_id.equals("000026")||user_id.equals("000034")){ %>&nbsp;<font style="{font: 8pt; color:666666;}">* 차량정비 및 거래처방문은 업무등록하면 끝나고, 그외 기타 업무를 기재하세요.</font>
		<% } %>&nbsp;<textarea name='content' rows='22' cols='70' readonly><%=content%></textarea></td>
				</tr>
			</table>
			<input type="hidden" name="acar_id" value="<%=acar_id%>">
			<input type="hidden" name="user_id" value="<%=user_id%>">			
			<input type="hidden" name="seq" value="<%=seq%>">
			<input type="hidden" name="start_year" value="<%=start_year%>">
			<input type="hidden" name="start_mon" value="<%=start_mon%>">
			<input type="hidden" name="start_day" value="<%=start_day%>">
			<input type="hidden" name="cmd" value="">
		</td>
	</tr>
	<tr>
	    <td>&nbsp;* 년차, 휴가(년차미포함,병가,경조사등)는 총무팀 이점미씨가  전담하여 관리합니다.</td>
	</tr>		
</form>
</table>



<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

</BODY>
</HTML>
