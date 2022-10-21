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
<%@ include file="/acar/access_log.jsp" %>

<%
	
	ScheduleDatabase csd = ScheduleDatabase.getInstance();
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
	
	if(request.getParameter("start_year")!=null) 	start_year	=request.getParameter("start_year");
	if(request.getParameter("start_mon")!=null) 	start_mon	=request.getParameter("start_mon");
	if(request.getParameter("start_day")!=null) 	start_day	=request.getParameter("start_day");
	if(request.getParameter("acar_id")!=null) 		acar_id		=request.getParameter("acar_id");
	if(request.getParameter("user_id")!=null) 		user_id		=request.getParameter("user_id");
	if(request.getParameter("seq")!=null) 			seq			=Util.parseInt(request.getParameter("seq"));
	if(request.getParameter("sch_chk")!=null) 		sch_chk		=request.getParameter("sch_chk");
	
	
	if(start_year.equals("")){
		start_year 	= AddUtil.getDate(1);
		start_mon 	= AddUtil.getDate(2);
		start_day 	= AddUtil.getDate(3);
	}
	
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
	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
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
function ScheReg()
{
	var theForm = document.ScheRegForm;
	theForm.start_year.value = theForm.start_yr.value;
	theForm.start_mon.value = theForm.start_mth.value;
	theForm.start_day.value = theForm.start_day.value;
	if(get_length(theForm.content.value) > 4000){
		alert("4000자 까지만 입력할 수 있습니다.");
		return;
	}
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	theForm.action = "sch_null_ui.jsp";
	theForm.submit();
}
function ScheUp()
{
	var theForm = document.ScheRegForm;
	theForm.start_year.value = theForm.start_yr.value;
	theForm.start_mon.value = theForm.start_mth.value;
	theForm.start_day.value = theForm.start_day.value;
	if(get_length(theForm.content.value) > 4000){
		alert("4000자 까지만 입력할 수 있습니다.");
		return;
	}
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "u";
	theForm.target = "i_no";
	theForm.action = "sch_null_ui.jsp";
	theForm.submit();
}
function ScheDel(){
	var theForm = document.ScheRegForm;
	theForm.start_year.value = theForm.start_yr.value;
	theForm.start_mon.value = theForm.start_mth.value;
	theForm.start_day.value = theForm.start_day.value;
	if(!confirm('삭제하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "d";
	theForm.target = "i_no";
	theForm.action = "sch_null_ui.jsp";
	theForm.submit();
}
function LoadSche()
{
	var theForm = opener.document.thefrm;
	theForm.submit();
	self.close();
	window.close();
}
function LoadSche2()
{
	var theForm = document.ScheRegForm;
	theForm.cmd.value = "";
	theForm.target = "_self";
	theForm.action = "sch_i.jsp";
	theForm.submit();
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
<table border="0" cellspacing="0" cellpadding="0" width=580>
    <tr>
    	<td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 업무일지관리 > 업무스케줄관리 > <span class=style5>일정등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
      
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <form action="./sch_null_ui.jsp" name='ScheRegForm' method='post'>
    <input type='hidden' name='go_url' value='<%=go_url%>'>
    <tr> 
        <td align='right'> 
        <%if(seq!=0){%>
        <a href="javascript:ScheUp()"><img src=../images/center/button_modify.gif border=0></a> 
		<%if(sch_chk.equals("1") || sch_chk.equals("2") || sch_chk.equals("0")){%>
		<%	if( acar_id.equals(user_id) || acar_id.equals("000029") || acar_id.equals("000063") ){%>
        <a href="javascript:ScheDel()"><img src=../images/center/button_delete.gif border=0></a>  		
		<%	}%>
		<%}%>
        <%}else{%>
        <a href="javascript:ScheReg()"><img src=../images/center/button_reg.gif border=0></a> 
        <%}%>
        <a href="javascript:LoadSche()"><img src=../images/center/button_close.gif border=0></a> 
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=580>
          <%if(1!=1){			
				//해당부서 사원리스트
				Vector users = c_db.getUserList("", "", "EMP");
				int user_size = users.size();
			%>
                <tr> 
                    <td width=60 class='title'>성명</td>
                    <td width=440 align='left'> 
                      &nbsp;&nbsp;<select name="acar_id">
                        <option value="">선택</option>
                        <!--default값으로 login 한 사용자가 선택되어있도록-->
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>대체업무자</td>
                    <td align='left' >
                      &nbsp;&nbsp;<select name="work_id">
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(work_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
        			  &nbsp;(년차,휴가,병가,경조사일때 - 전자문서 결재 대체자)
                    </td>
                </tr>		  			  
                <%}else{%>
                <input type="hidden" name="acar_id" value="<%=user_id%>">
                <%}%>
                <tr> 
                    <td width=60 class='title'>구분</td>
                    <td width=440  align='left' > 
                      &nbsp;&nbsp;<select name="sch_chk">
                        <option value="1" <%if(sch_chk.equals("1")){%>selected<%}%>>업무일지</option>
                        <option value="2" <%if(sch_chk.equals("2")){%>selected<%}%>>현지출근</option>
                        <%//if(user_bean.getLoan_st().equals("")){%>    
                        <option value="0" <%if(sch_chk.equals("0")){%>selected<%}%>>재택근무</option>
                        <%//} %>
                      </select>
                      
                      <%if(!user_bean.getLoan_st().equals("")){%>
                          ※ 코로나19 입원 및 자가격리는 연차,공가 등록만 가능합니다.
                      <%} %>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>제목</td>
                    <td align='left' > 
                      &nbsp;&nbsp;<input type='text' name='title' value="<%=title%>" size='70' MAXLENGTH='70' class=text>
                    </td>
                </tr>
                <!-- 
                <tr> 
                    <td class='title'>일정</td>
                    <td> 
                      &nbsp;&nbsp;<input type='radio' name='sch_kd' value='1' <%if(sch_kd.equals("1")||sch_kd.equals("")) out.print("checked");%>>
                      개인&nbsp; 
                      <input type='radio' name='sch_kd' value='2' <%if(sch_kd.equals("2")) out.print("checked");%>>
                      공유&nbsp; </td>
                </tr>
                 -->
                <tr> 
                    <td class='title'>일자</td>
                    <td>                     
                      &nbsp;&nbsp;<script language="javascript">init2(5,<%=start_year%>,<%=start_mon%>,<%=start_day%>); init_display("start");</script>
                      <%if(seq!=0){ %>※ 날짜 수정은 안됩니다. 삭제하고 다시 등록하세요.<%} %>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>내용</td>
                    <td> 
                      &nbsp;&nbsp;<textarea name='content' rows='21' cols='71'><%=content%></textarea>
                    </td>
                </tr>
            </table>
            <input type="hidden" name="seq" value="<%=seq%>">
            <input type="hidden" name="start_year" value="<%=start_year%>">
            <input type="hidden" name="start_mon" value="<%=start_mon%>">
            <input type="hidden" name="start_day" value="<%=start_day%>">			
            <input type="hidden" name="cmd" value="">
			<input type="hidden" name="m_st"  value="<%=m_st%>">
			<input type="hidden" name="m_st2" value="<%=m_st2%>">
			<input type="hidden" name="m_cd"  value="<%=m_cd%>">
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>    
    
<%	
	user_id = acar_id;
	String dept_id = c_db.getUserDept(user_id);
	if(dept_id.equals("0001")){
		Vector EstiIngList = EstiMngDb.getEstiList("", "", user_id, "", "7", "", "", "", start_year+start_mon+start_day, start_year+start_mon+start_day, "", "", "", "", "", "", "", "");	
%>	
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



<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</BODY>
</HTML>
