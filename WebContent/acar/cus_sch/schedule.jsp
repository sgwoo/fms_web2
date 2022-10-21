<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_sche.*, acar.car_service.*, acar.cus_sch.*"%>
<%@ page import="acar.cus0401.*, acar.cus0402.*, acar.cus0403.*" %>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<jsp:useBean id="c41_scBn" class="acar.cus0401.Cus0401_scBean" scope="page"/>
<jsp:useBean id="c42_cvBn" class="acar.cus0402.Cycle_vstBean" scope="page"/>
<jsp:useBean id="c43_scBn" class="acar.cus0403.Cus0403_scBean" scope="page"/>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String myid = user_id;
	
	int start_year = request.getParameter("start_year")==null?0:AddUtil.parseInt(request.getParameter("start_year"));
	int start_month = request.getParameter("start_month")==null?0:AddUtil.parseInt(request.getParameter("start_month"));
	int start_day = 1;
	int nyear = 0;
	int nmonth = 0;
	int nday = 0;
	int cnt = 1;
	
	if(start_year==0){
		nyear = calendar.getThisYear();
		nmonth = calendar.getThisMonth();
		nday = calendar.getThisDay();
	}else{
		nyear = start_year;
		nmonth = start_month;
		nday = start_day;
	}
	String thisyear = Integer.toString(nyear);
	String thismonth = Integer.toString(nmonth);
	String thisday = Integer.toString(nday);
	if(thismonth.length() == 1)		thismonth = "0"+thismonth;
	if(thisday.length() == 1)		thisday = "0"+thisday;
	
	int day_of_week = 0;
	int last_day = calendar.getMonthLastDay(nyear,nmonth); 	
	
	String tr_color = "";
	String whatday = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//업무일지
	CarSchDatabase schedule = CarSchDatabase.getInstance();
	CarScheBean cs_r [] = schedule.getCarScheAll(thisyear,thismonth,myid);
	
	//순회방문-거래처
	CusSch_Database cs_db = CusSch_Database.getInstance();
	Cycle_vstBean[] cvBns = cs_db.getCycle_vst(thisyear, thismonth, myid);
//System.out.println("cvBns.length="+cvBns.length);	
	Vector sl = cs_db.getService(thisyear, thismonth, myid);
	Vector cml = cs_db.getCar_maint(thisyear, thismonth, myid);
//System.out.println("size="+cml.size());
	//정비건.
	CarServDatabase csd = CarServDatabase.getInstance();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/index.css">
<script language='javascript'>
<!--
//이전월
function go_before(year, mon){
	var fm = document.form1;
	var cur_mon = mon - 1;
	var cur_year = year;

	if(cur_mon < 1)	{
		cur_mon = 12;
		cur_year = year - 1 ;
	}

	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.submit();
}
//이전년도
function go_before2(year, mon){
	var fm = document.form1;
	var cur_mon = mon;
	var cur_year = year-1;

	if(cur_year < 1)	{
		cur_year = 1 ;
	}

	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.submit();
}
//다음월
function go_next(year, mon){
	var fm = document.form1;
	var cur_mon = mon + 1;
	var cur_year = year;

	if(cur_mon > 12){
		cur_mon = 1;
		cur_year = year + 1 ;
	}

	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.submit();
}
//다음년도
function go_next2(year, mon){
	var fm = document.form1;
	var cur_mon = mon;
	var cur_year = year+1;

	if(cur_year > 9999){
		cur_year = 9999;
	}

	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.submit();
}
//리스트로 이동
function go_list(idx, date, user_id){
	if(idx == '21') 	  url = "/acar/cus0401/cus0401_s_frame.jsp?gubun1=21&gubun2=4&gubun3=P&st_dt="+ date +"&end_dt="+ date +"&s_kd=8&t_wd="+user_id;
	else if(idx == '22') url = "/acar/cus0402/cus0402_s_frame.jsp?gubun1=22&gubun2=4&gubun3=P&st_dt="+ date +"&end_dt="+ date +"&s_kd=8&t_wd="+user_id;
	else if(idx == '23') url = "/acar/cus0403/cus0403_s_frame.jsp?gubun1=23&gubun2=4&gubun3=P&st_dt="+ date +"&end_dt="+ date +"&s_kd=8&t_wd="+user_id;
	document.location.href = url;
}
function ScheDisp(id, seq, year, mon, day)
{
	var theForm = document.form1;
	var auth_rw = theForm.auth_rw.value;
	
	var url = "?auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_mon=" + mon
			+ "&start_day=" + day
			+ "&acar_id=" + id
			+ "&seq=" + seq;

	var SUBWIN="./sch_c.jsp" + url;	
	
	window.open(SUBWIN, "SchDisp", "left=100, top=100, width=600, height=600, scrollbars=yes");
}
function SchReg(year, mon, day, id)
{
	var theForm = document.form1;
	var auth_rw = theForm.auth_rw.value;
	
	var url = "?auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_mon=" + mon
			+ "&start_day=" + day
			+ "&acar_id=" + id;

	var SUBWIN="./sch_i.jsp" + url;	
	
	window.open(SUBWIN, "SchReg", "left=100, top=100, width=600, height=600");
}
function cusVisitDisp(client_id, seq)
{
	var theForm = document.form1;
	var auth_rw = theForm.auth_rw.value;
	
	var url = "?auth_rw=" + auth_rw
			+ "&client_id=" + client_id
			+ "&seq=" + seq;

	var SUBWIN="/acar/cus_reg/vst_reg.jsp" + url;	
	
	window.open(SUBWIN, 'popwin_vst_reg','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50');
}
function carServDisp(car_mng_id, serv_id){
	var theForm = document.form1;
	var auth_rw = theForm.auth_rw.value;	
	var url = "?auth_rw=" + auth_rw
			+ "&car_mng_id=" + car_mng_id
			+ "&serv_id=" + serv_id;

	var SUBWIN="/acar/cus_reg/serv_reg.jsp" + url;	
	
	window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=50,left=50');
}
function next_serv_cng(car_mng_id, serv_id){
	var theForm = document.form1;
	var auth_rw = theForm.auth_rw.value;	
	var url = "?auth_rw=" + auth_rw
			+ "&car_mng_id=" + car_mng_id
			+ "&serv_id=" + serv_id;

	var SUBWIN="next_serv_cng.jsp" + url;	
	
	window.open(SUBWIN, 'popwin_next_serv_cng','scrollbars=yes,status=no,resizable=no,width=440,height=150,top=200,left=500');
}
function search(){
	fm = document.form1;
	fm.submit();
}
-->
</script>
</head>

<body leftmargin=15>
<form name='form1' method='post' action='schedule.jsp'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='start_year' value='<%=thisyear%>'>
<input type='hidden' name='start_month' value='<%=thismonth%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 업무추진관리 > <span class=style5>업무스케줄관리(개인)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ddj.gif" align=absmiddle>&nbsp;
          <select name='user_id'>
            <option value="">==선택==</option>
            <%	if(user_size > 0){
    						for (int i = 0 ; i < user_size ; i++){
    							Hashtable user = (Hashtable)users.elementAt(i);	%>
            <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
            <%		}
    					}		%>
          </select> <a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a> 
        </td>
    </tr>
    <tr>
       <td align=center>
        		    <a href="javascript:go_before2(<%=nyear%>,<%=nmonth%>);"><img src=../images/center/button_b_year.gif align=absmiddle border=0></a>&nbsp;
        			<a href='javascript:go_before(<%=nyear%>,<%=nmonth%>);' class=hh><img src=../images/center/button_b_month.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
        			<b class=sub><%=thisyear%>년&nbsp;<%=thismonth%>월</b>&nbsp;&nbsp;&nbsp;
        			<a href='javascript:go_next(<%=nyear%>,<%=nmonth%>);' class=hh><img src=../images/center/button_n_month.gif align=absmiddle border=0></a>&nbsp;
        			<a href="javascript:go_next2(<%=nyear%>,<%=nmonth%>);"><img src=../images/center/button_n_year.gif align=absmiddle border=0></a> 
        		    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td style='font-size:8pt'><font color=666666><font color=ff00ff>* 날짜 클릭</font> - 담당자의 해당일 업무일지 팝업<br>
        <font color=ff00ff>* 거래처방문,자동차정비,운행차검사 클릭</font> - 담당자의 해당일 리스트로 이동<br>
        <font color=ff00ff>* 실시 클릭</font> - 세부페이지 팝업 &nbsp;<font color=ff00ff>* 미실시 클릭</font> - 예정일자 변경페이지 팝업</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr> 
    <tr>
        <td class="line" bgcolor=#7A9494>
            <table width=100% cellspacing=1 cellpadding=0 border=0>
		  
          <!--오늘 스케줄-->
                <tr bgcolor=#e2e7ff> 
                    <td colspan=3 height=3><img src=../image/blank.gif height=3></td>
                </tr>
          <%	
					for(int i = 1 ; i < last_day + 1 ; i++){
						day_of_week = calendar.getDayOfWeek(nyear, nmonth, i);
						tr_color = "#FFFFFF";//평일
						whatday = AddUtil.parseDateWeek("c", day_of_week);
						if(day_of_week == 1)		tr_color = "#FEE6E6"; //일요일
						else if(day_of_week == 7)	tr_color = "#EEF5F9"; //토요일
						if(AddUtil.getDate2(3) == i)	tr_color = "#E8FEE6"; // 현재 날짜 포인트
			  %>
                <tr bgcolor=<%=tr_color%>> 
                    <td width=12% rowspan="4" align=center id='d<%=i%>'><a href="javascript:SchReg('<%=thisyear%>','<%=thismonth%>','<%if(i < 10){%>0<%}%><%=i%>','<%=myid%>')" border='0'> 
                          <%if(day_of_week == 1){// 일욜일 체크%>
                          <b class=c><%=i%>일<%=whatday%></b> 
                          <%}else if(day_of_week == 7){%>
                          <b class=f><%=i%>일<%=whatday%></b> 
                          <%}else{%>
                          <%=i%>일<%=whatday%> 
                          <%}%>
                          </a></td>
                    <td colspan="2"><a name="<%=thisyear%><%=thismonth%><%=i%>">&nbsp; 
                          <%for(int j=0; j<cs_r.length; j++){
            			        	cs_bean = cs_r[j];
            						if((Integer.parseInt(cs_bean.getStart_day()) == i) && (myid.equals(cs_bean.getUser_id()))){				
            							out.print("<a href='javascript:ScheDisp(\""+cs_bean.getUser_id()+"\",\""+cs_bean.getSeq()+"\",\""+cs_bean.getStart_year()+"\",\""+cs_bean.getStart_mon()+"\",\""+cs_bean.getStart_day()+"\")' border='0' class=copy> ["+cs_bean.getSch_chk()+"] "+cs_bean.getTitle()+"</a><BR>");
            						}
            					}%></a></td>
                </tr>
                <tr align=center bgcolor=<%=tr_color%>> 
                    <td width=11%><a href="javascript:go_list('22','<% if(i<10){ out.print(thisyear+thismonth+"0"+i); }else{ out.print(thisyear+thismonth+i); } %>','<%= user_id %>');"><span class=style2>거래처방문</span></a></td>
                    <td align=left width=77%> 
                        <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <%		cnt=1;
            				for(int j=0; j<cvBns.length; j++){
            		        	c42_cvBn = cvBns[j];
            					if(c42_cvBn.getVst_est_dt().equals(""))	continue;						
            					if(Integer.parseInt(c42_cvBn.getVst_est_dt().substring(6,8)) == i){
            				%>
                            <tr> 
                                <td width="3%"><%= cnt++ %>.</td>
                                <td width="35%"><span title="<%= c_db.getNameById(c42_cvBn.getClient_id(),"CLIENT") %>"><%= AddUtil.subData(c_db.getNameById(c42_cvBn.getClient_id(),"CLIENT"),8) %></span></td>
                                <td width=52%><%= c42_cvBn.getVst_est_cont() %></td>
                                <td width=10% align="center"> <% if(c42_cvBn.getVst_dt().equals("")){ %> <a href="javascript:cusVisitDisp('<%= c42_cvBn.getClient_id() %>','<%= c42_cvBn.getSeq() %>')"><font color="#FF0000"><img src=/acar/images/center/button_in_nss.gif align=absmiddle border=0></font></a> 
                                <% }else{ %> <font color="#FF0000"><a href="javascript:cusVisitDisp('<%= c42_cvBn.getClient_id() %>','<%= c42_cvBn.getSeq() %>')"><img src=/acar/images/center/button_in_ss.gif align=absmiddle border=0></a></font> 
                                <% } %> </td>
                            </tr>
                            <% 
            					}
            				}%>
                        </table>
                    </td>
                </tr>
                <tr align=center bgcolor=<%=tr_color%>> 
                    <td><a href="javascript:go_list('21','<% if(i<10){ out.print(thisyear+thismonth+"0"+i); }else{ out.print(thisyear+thismonth+i); } %>','<%= user_id %>');"><span class=style2>자동차정비</span></a></td>
                    <td align=left> 
                        <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <%		cnt = 1;
            				for(int j=0; j<sl.size(); j++){
            			       	Hashtable ht = (Hashtable)sl.elementAt(j);
            					String nsdt = (String)ht.get("NEXT_SERV_DT");
            					String sst = (String)ht.get("SERV_ST");
            					String sdt = (String)ht.get("SERV_DT");
            					String dt = nsdt;
            					if(nsdt.equals(""))	dt = sdt;
            //System.out.println("dt="+dt);					
            					if((!dt.equals(""))&&AddUtil.parseInt(dt.substring(6,8)) == i){					
            				%>
                            <tr> 
                                <td width="3%"><%= cnt++ %>.</td>
                                <td width="20%"><span title="<%= ht.get("FIRM_NM") %>"><%= AddUtil.subData((String)ht.get("FIRM_NM"),8) %></span></td>
                                <td width="15%"><%= ht.get("CAR_NO") %></td>
                                <td width="25%">[ 
                                <% if(sst.equals("1")){ out.print("순회점검");
            				  					}else if(sst.equals("2")){ out.print("일반수리");
            									}else if(sst.equals("3")){ out.print("보증수리");
            									} %>
                                ]</td>
                                <td width=27%><% if(!sdt.equals("")){
            							ServItem2Bean si_r [] = csd.getServItem2All((String)ht.get("CAR_MNG_ID"),(String)ht.get("SERV_ID"));
            							for(int k=0; k<si_r.length; k++){
            								si_bean = si_r[k];
            								if(k==0){%> 
                                <%=si_bean.getItem()%> 외 <font color="red"> 
                                <%if(si_r.length>1){ out.print(si_r.length-1); }else{ out.print(si_r.length); }%>
                                </font>건 
                                <%}
            							}
            						 }
            							%></td>
                                <td width=10% align="center"><% if(sdt.equals("")){ %> <a href='javascript:next_serv_cng("<%= ht.get("CAR_MNG_ID") %>","<%= ht.get("SERV_ID") %>")'><font color="#FF0000"><img src=/acar/images/center/button_in_nss.gif align=absmiddle border=0></font></a> 
                                <% }else{ %> <font color="#FF0000"><a href='javascript:carServDisp("<%= ht.get("CAR_MNG_ID") %>","<%= ht.get("SERV_ID") %>")'><img src=/acar/images/center/button_in_ss.gif align=absmiddle border=0></a></font> 
                                <% } %></td>
                            </tr>
                            <%
            					}
            				}%>
                        </table>
                    </td>
                </tr>
                <tr align=center bgcolor=<%=tr_color%>> 
                    <td><a href="javascript:go_list('23','<% if(i<10){ out.print(thisyear+thismonth+"0"+i); }else{ out.print(thisyear+thismonth+i); } %>','<%= user_id %>');"><span class=style2>운행차검사</span></a></td>
                    <td align=left> 
                        <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <%	 cnt = 1;
            				for(int j=0; j<cml.size(); j++){
            			       	Hashtable ht = (Hashtable)cml.elementAt(j);
            					String med = (String)ht.get("MED");
            					String ckd = (String)ht.get("CKD");
            					String mcd = (String)ht.get("MCD");
            					if(Integer.parseInt(med.substring(6,8)) == i){
            				%>
                            <tr> 
                                <td width="3%"><%= cnt++ %>.</td>
                                <td width="20%"><span title="<%= ht.get("FIRM_NM") %>"><%= AddUtil.subData((String)ht.get("FIRM_NM"),8) %></span></td>
                                <td width="15%"><%= ht.get("CAR_NO") %></td>
                                <td width="25%">[ 
                                <% if(ckd.equals("1")){ out.print("정기검사");
            				  					}else if(ckd.equals("2")){ out.print("정기정밀검사");
            									}else{ out.print("정기검사");
            									} %>
                                ]</td>
                                <td width=27%><%= ht.get("CMP") %></td>
                                <td width="10%" align="center"><% if(ckd.equals("")){ %>
            				  			<font color="#FF0000">미실시</font> 
                                <% }else{ %>
            							<font color="#666666">실시</font> 
                                <% } %></td>
                            </tr>
                            <%
            					}
            				}%>
                          </table>
                      </td>
                </tr>
                <tr bgcolor=#e2e7ff> 
                    <td colspan=3 height=1></td>
                </tr>
                      <%}%>
                <tr bgcolor=#e2e7ff> 
                    <td colspan=3 height=1></td>
                </tr>
                <tr bgcolor=#e2e7ff> 
                    <td colspan=3 height=1></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
