<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.user_mng.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.free_time.*" %>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String doc_no = request.getParameter("doc_no")==null?"":request.getParameter("doc_no");	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	String chk = request.getParameter("chk")==null?"":request.getParameter("chk");	
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	
	
	String title = "";	
	String title1 = "";	
	String sch_file = "";	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//연차신청정보
	Hashtable ht= ft_db.absence_per(user_id, doc_no);
%>

<HTML>
<HEAD>
<TITLE>fms</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--

function absence_reg(cmd){
	var theForm = document.form1;
	
	if(cmd== 'i' || cmd== 'ii'){
		if(!confirm('등록하시겠습니까?'))
		{
			return;
		}
		theForm.cmd.value = cmd;
	} else if (cmd== 'm' ){
			
			if(theForm.m_start_day.value == '')				{ alert('휴직변경 시작일을 입력하십시오'); 		theForm.m_start_day.focus(); 	return;	}
			if(theForm.m_end_day.value == '')				{ alert('휴직변경 종료일을 입력하십시오'); 		theForm.m_end_day.focus(); 		return;	}
			
			if(!confirm('기간변경하시겠습니까?'))
			{
				return;
			}
			theForm.cmd.value = cmd;	
	}else{
		if(!confirm('수정하시겠습니까?'))
		{
			return;
		}
		theForm.cmd.value = "u";
	}
	theForm.target = "i_no";
	theForm.action = "absence_a.jsp";	
	theForm.submit();
}

function free_close()
{
	var theForm = document.form1;
	theForm.submit();
	self.close();
	window.close();
}
	
	
//-->
</script>
</HEAD>
<BODY>
<center>
<table border="0" cellspacing="0" cellpadding="0" width=600>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > 휴직현황 ><span class=style5><%if(chk.equals("I")){%>보험료납부유예 (등록/수정)<%}else{%>보험료납부재개<%}%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="" name='form1' method='post'>
		<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
		<input type="hidden" name="doc_no" value="<%=doc_no%>">
		<input type="hidden" name="cmd" value="">	
		<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  	
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=600>
				<tr> 
					<td colspan="4" style="text-align:center; background-color: #A0BAED; color: #4B4B4B; font-weight:700;">기본정보</td>
				</tr>
				<tr> 
                    <td class='title' colspan="2">성명</td>
					<td class='title' colspan="2">구분</td>
                </tr>
                <tr> 
                    <td align='center' colspan="2" ><%=ht.get("USER_NM")%></td>
					<td align='center' colspan="2"><%=ht.get("TITLE")%></td>
				</tr>
				<tr> 
                    <td class='title'>부서명</td>
					<td class='title'>시작일</td>
					<td class='title'>종료일</td>
					<td class='title'>기간(월)</td>
                </tr>
				<tr> 
                    <td align='center'><%=ht.get("DEPT_NM")%></td>
					<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DATE")))%></td>
					<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DATE")))%></td>
					<td align='center'><%=ht.get("M")%></td>
                </tr>
                
				<tr></tr>
				<!-- 휴직기간 변경 : 전산팀에서 처리하면서 pl 연동 데이타 생성  -->
				 <%	if( nm_db.getWorkAuthUser("전산팀",ck_acar_id) ){%>
				<tr> 
                    <td align='center'>[휴직기간]</td>
					<td align='center'><input type="text" name="m_start_day" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("M_START_DAY")))%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td align='center'><input type="text" name="m_end_day" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("M_END_DAY")))%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td align='center'><input type="text" name="t_dt" size="15" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("T_DT")))%>' style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'> <a href="javascript:absence_reg('m')">[변경]</a></td>
                </tr>
				<% } %>
				
				<tr> 
					<td colspan="4" style="text-align:center; background-color: #A0BAED; color: #4B4B4B; font-weight:700;">보험료납부유예(등록/수정)</td>
				</tr>
                <tr> 
                    <td class='title'>보험구분</td>
					<td class='title'>시작일</td>
					<td class='title'>종료일</td>
					<td class='title'>처리일</td>
                </tr>
				<tr> 
                    <td align='center'><input type='hidden' name="gubun" value='KK'>건강보험</td>
					<td align='center'><%if(chk.equals("II")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DTKK")))%><%}else{%><input type="text" name="start_dt" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DTKK")))%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'><%}%></td>
					
					<td align='center'><%if(chk.equals("II")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DTKK")))%><%}else{%><input type="text" name="end_dt" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DTKK")))%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'><%}%></td>
					
					<td align='center'><%if(chk.equals("II")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JSE_DTKK")))%><%}else{%><input type="text" name="jse_dt" value='<%if(!AddUtil.ChangeDate2(String.valueOf(ht.get("JSE_DTKK"))).equals("")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JSE_DTKK")))%><%}else{%><%=Util.getDate()%><%}%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'><%}%></td>
                </tr>
				<tr> 
                    <td align='center'><input type='hidden' name="gubun" value='KM'>국민연금</td>
					<td align='center'><%if(chk.equals("II")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DTKM")))%><%}else{%><input type="text" name="start_dt" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DTKM")))%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'><%}%></td>
					
					<td align='center'><%if(chk.equals("II")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DTKM")))%><%}else{%><input type="text" name="end_dt" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DTKM")))%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'><%}%></td>
					
					<td align='center'><%if(chk.equals("II")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JSE_DTKM")))%><%}else{%><input type="text" name="jse_dt" value='<%if(!AddUtil.ChangeDate2(String.valueOf(ht.get("JSE_DTKM"))).equals("")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JSE_DTKM")))%><%}else{%><%=Util.getDate()%><%}%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'><%}%></td>
                </tr>
				<tr>
					<td align='right' colspan="4">
					<%if(chk.equals("I")){%>
						<a href="javascript:absence_reg('i')"><%if(AddUtil.ChangeDate2(String.valueOf(ht.get("JSE_DTKM"))).equals("")){%><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle><%}else{%><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle><%}%></a>
						<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
					<%}%>
					</td>
				</tr>
				<tr>
				</tr>
			</table>
			<%if(chk.equals("II")){%>
			 <table border="0" cellspacing="1" cellpadding="0" width=600>
				<tr> 
					<td colspan="4" style="text-align:center; background-color: #A0BAED; color: #4B4B4B; font-weight:700;">보험료납부재개</td>
				</tr>
                <tr> 
                    <td class='title'>보험구분</td>
					<td class='title' colspan="3">처리일</td>
                </tr>
				<tr> 
                    <td align='center'><input type='hidden' name="gubun" value='KK'>건강보험</td>
					<td align='center' colspan="3"><input type="text" name="kkjss_dt" value='<%if(!AddUtil.ChangeDate2(String.valueOf(ht.get("JSS_DTKK"))).equals("")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JSS_DTKK")))%><%}else{%><%//=Util.getDate()%><%}%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
				<tr> 
                    <td align='center'><input type='hidden' name="gubun" value='KM'>국민연금</td>
					<td align='center' colspan="3"><input type="text" name="kmjss_dt" value='<%if(!AddUtil.ChangeDate2(String.valueOf(ht.get("JSS_DTKM"))).equals("")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JSS_DTKM")))%><%}else{%><%//=Util.getDate()%><%}%>' size="15" style="font-size : 9pt; text-align:center; border:1 solid #acacac; background-color:#ffffff; font-family: DOTUM; color:#303030;" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
				<tr>
					<td align='right' colspan="4">
						<a href="javascript:absence_reg('ii')"><%if(AddUtil.ChangeDate2(String.valueOf(ht.get("JSS_DTKM"))).equals("")){%><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle><%}else{%><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle><%}%></a>
						<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
					</td>
				</tr>
            </table>
			<%}%>			
		</td>

	</tr>	
	        
   
	
</form>
</table>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
