<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*,acar.common.*" %>
<%@ page import="acar.car_sche.*" %>
<%@ page import="acar.schedule.*, acar.esti_mng.*, acar.user_mng.*" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="EstiMngDb" scope="page" class="acar.esti_mng.EstiMngDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarSchDatabase csd = CarSchDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
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
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
%>

<HTML>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
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
<table border="0" cellspacing="0" cellpadding="0" width=580>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 업무일지관리 > 업무스케줄관리 > <span class=style5>일정보기</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./sch_i.jsp" name='ScheDispForm' method='post'>
	<tr>
		<td align='right'>
		<%if(sch_chk.equals("1") || sch_chk.equals("2") || sch_chk.equals("0")){%>
		<%	if(acar_id.equals(user_id) || acar_id.equals("000029") || acar_id.equals("000063")){%>			
			<a href="javascript:ScheUpDisp()"><img src=../images/center/button_modify_s.gif align=absmiddle border=0></a>
			<%}%>
		<%}%>		
		<a href="javascript:self.close();window.close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a> 
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=580>
                <tr>
        			<td width=120 class='title'>성명</td>				
                    <td width=380 align=left>&nbsp;<%=user_nm%></td>
		        </tr>
		        <tr>					
                    <td width=120 class='title'>구분</td>
        			<td width=380 align=left>
        			  &nbsp;<select name="sch_chk" disabled>
        				<option value="1" <%if(sch_chk.equals("1")) out.print("selected");%>>업무일지</option>
        				<option value="2" <%if(sch_chk.equals("2")) out.print("selected");%>>현지출근</option>
        				<%//if(user_bean.getLoan_st().equals("")){%>            				
        				<option value="0" <%if(sch_chk.equals("0")) out.print("selected");%>>재택근무</option>
        				<%//} %>        				
        			  </select>					
        			</td>
		        </tr>
			    <tr>
    			    <td width='120' class='title'>대체업무자</td>					
                    <td align=left>&nbsp;<%=c_db.getNameById(work_id,"USER")%>
    				&nbsp;(년차,휴가,병가,경조사일때 - 전자문서 결재 대체자)</td>
			    </tr>														  
		        <tr>
        			<td width=120 class='title'>제목</td>					
                    <td width=380 align=left> &nbsp;<%=title%>
        			  &nbsp;<input type='hidden' name='title' value="" ></td>
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
        			<td>
                      &nbsp;<textarea name='content' rows='20' cols='71' readonly><%=content%></textarea>
                    </td>
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
<%	String dept_id = c_db.getUserDept(user_id);
	if(dept_id.equals("0001")){
		Vector EstiIngList = EstiMngDb.getEstiList("", "", user_id, "", "7", "", "", "", start_year+start_mon+start_day, start_year+start_mon+start_day, "", "", "", "", "", "", "", "");%>	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;<img src=../images/center/arrow_gjgr.gif></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class="line"> 
            <table width="580" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td class="title" width="30">연번</td>
                    <td class="title" width="100">영업사원</td>
                    <td class="title" width="115">거래처</td>
                    <td class="title" width="115">차종</td>
                    <td class="title" width="80">견적일자</td>
                    <td class="title" width="80">Update일자</td>
                    <td class="title" width="60">상태</td>
                </tr>
          <% if(EstiIngList.size()>0){
				for(int i=0; i<EstiIngList.size(); i++){ 
					Hashtable ht = (Hashtable)EstiIngList.elementAt(i); 
					String ment = "";
					if(!String.valueOf(ht.get("CNT")).equals("0")){
//						ment = "["+ AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT"))) +"] "+ ht.get("TITLE") +"\n\n"+ ht.get("CONT");
						ment = "제목: "+ ht.get("TITLE") +"\n\n내용: "+ ht.get("CONT");						
					}
					%>		  
                <tr> 
                    <td width="25" align=center><%= i+1 %></td>
                    <td width="85" align=center><span title='<%= ht.get("CAR_COMP_NM") %> <%= ht.get("CAR_OFF_NM") %>'><%=Util.subData(String.valueOf(ht.get("EMP_NM"))+" "+String.valueOf(ht.get("EMP_POS")), 6)%></span></td>
                    <td width="100" align=center><span title='<%= ht.get("EST_NM") %> <%= ht.get("EST_MGR") %>'><%=Util.subData(String.valueOf(ht.get("EST_NM"))+" "+String.valueOf(ht.get("EST_MGR")), 7)%></span></td>
                    <td width="100" align=center>
                      <%if(String.valueOf(ht.get("CAR_TYPE")).equals("2")){%>
                      <span title='<%= ht.get("CAR_NAME") %>'><font color="#990000">[<%= ht.get("CAR_NO") %>]</font> 
                      <%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 5)%></span> 
                      <%}else{%>
                      <span title='<%= ht.get("CAR_NAME") %>'><%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 8)%></span> 			  
                      <%}%>				
        			</td>
                    <td width="70" align=center><%= AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT"))) %></td>
                    <td align=center><span title='<%= ment %>'><%= AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT"))) %></span></td>
                    <td align=center><%= ht.get("EST_ST_NM") %></td>
                </tr>
          <% 		}
			}else{ %>
                <tr> 
                    <td colspan="7" align='center'>해당 데이터가 없습니다.</td>
                </tr>
          <% } %>		  
            </table>
        </td>
    </tr>
<%	}%>	
	
	</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>
