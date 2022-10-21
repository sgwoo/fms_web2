<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.attend.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	Hashtable ht = new Hashtable();
	Hashtable ht2  = new Hashtable();
	Hashtable ht3   = new Hashtable();
	int b_su = 0; //오후반차-오전반차 = 2 이상인경우
		
	Vector vt =  new Vector();

	ht = v_db.getVacation(user_id);
   
	vt = v_db.getVacationList(user_id, (String)ht.get("YEAR"));
	
	ht2 = v_db.getVacationBan(user_id); //누적반차 현황
	ht3 = v_db.getVacationBan2(user_id);  //현재 반차 현황
	
	b_su =   AddUtil.parseInt((String)ht3.get("B2")) - AddUtil.parseInt((String)ht3.get("B1"));
	b_su= Math.abs(b_su);
		
	String use_dt ="";		
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

//-->	
</script>
</head>
<script language="JavaScript">
//데이타 삭제
function sch_d(sch_id, sch_year, sch_mon, sch_day, seq){
	
	var fm = document.form1;
	
	fm.sch_id.value 	= sch_id;
	fm.start_year.value 	= sch_year;
	fm.start_mon.value 	= sch_mon;
	fm.start_day.value 	= sch_day;
	fm.seq.value 	= seq;
	
	if(confirm('삭제하시겠습니까?')){				
		fm.action='sch_d_a.jsp';					
		fm.target = 'i_no';
		fm.submit();
	}	
			
}
</script>

<body> 
<form name="form1" method='post'>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="sch_id" >
<input type="hidden" name="start_year" >
<input type="hidden" name="start_mon" >
<input type="hidden" name="start_day" >
<input type="hidden" name="seq" >

<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>연차관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
  <% if(auth_rw.equals("6")){ %>
    <tr> 
        <td align="right">
			<a href="./vacation_all_new.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>"><img src=../images/center/button_see_all.gif border=0 align=absmiddle></a>
		</td>
    </tr>
  <% } %>
  
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table  width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=8% rowspan="3" class="title">근무지</td>
                    <td width=8% rowspan="3" class="title">부서</td>
                    <td width=6% rowspan="3" class="title">직급</td>
                    <td width=8% rowspan="3" class="title">성명</td>
                    <td width=8% rowspan="3" class="title">입사일</td>                 
                    <td colspan="3" class="title">계속근무기간</td>
                    <td colspan="4" class="title" width=20% >근로기준법 기준</td>
                    <td colspan="4" class="title" width=20% >사규기준 {이월(기한 30일 연장)}</td>	
                    <td width="6%" rowspan="3" class="title">반휴가현황<br>오전:오후</td>
                    <td width=4% rowspan="3" class="title">무급</td> 
                </tr>
                <tr> 
                    <td width=4% rowspan="2" class="title">년</td>
                    <td width=4% rowspan="2" class="title">월</td>
                    <td width=4% rowspan="2" class="title">일</td>
                    <td colspan="3" class="title">사용현황</td>
                    <td width=8% rowspan="2" class="title">사용기한</td>
                    <td colspan="3" class="title">사용현황</td>
                    <td width=8% rowspan="2" class="title">미사용연차<br>소멸예정일</td>                                  		               
                </tr>
                <tr> 
                    <td width=4% class="title">가용</td>
                    <td width=4% class="title">사용</td>
                    <td width=4% class="title">미사용</td>
                    <td width=4% class="title">이월</td>
                    <td width=4% class="title">사용</td>
                    <td width=4% class="title">미사용</td>                  
                </tr>
                <tr> 
                    <td align="center"><%= ht.get("BR_NM") %></td>
                    <td align="center"><%= ht.get("DEPT_NM") %></td>
                    <td align="center"><%= ht.get("USER_POS") %></td>
                    <td align="center"><%= ht.get("USER_NM") %>
               <!--        <a href="javascript:MM_openBrWindow('vacation_force_view.jsp?auth_rw=1&user_id=<%= ht.get("USER_ID") %>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=460,height=400,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="미사용연차통보내역보기"></a>&nbsp; -->
                    </td>
                    <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("ENTER_DT")) %></td>
                    <td align="center"><%= ht.get("YEAR") %></td>
                    <td align="center"><%= ht.get("MONTH") %></td>
                    <td align="center"><%= ht.get("DAY") %></td>
                    <td align="center"><b><%= ht.get("VACATION") %></b></td>
                    <td align="center"><font style="color:red;"><b><%= ht.get("SU") %></b></font></td>
                    <td align="center"><font style="color:blue;"><b><%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("OV_CNT")) %></b></font></td>
                  
 <% if ( ht.get("YEAR").equals("0")) { %>
 					<td align="center">&nbsp;</td>
 <% } else { %>                   
					<td align="center"><%= AddUtil.ChangeDate2((String)ht.get("END_DT")) %></td>       
 <% }  %>                     
					
<% if ( AddUtil.parseInt(String.valueOf(ht.get("D_90_DT")))   <= AddUtil.parseInt(String.valueOf(ht.get("TODAY"))) ) { %> 		
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	
	    			<td  width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("C_DUE_DT")) %></td>	 

<% } else {  %>					
	<% if ( String.valueOf(ht.get("REMAIN")).equals("") || String.valueOf(ht.get("REMAIN")).equals("0") || AddUtil.parseInt(String.valueOf(ht.get("DUE_DT")))  <= AddUtil.parseInt(String.valueOf(ht.get("TODAY"))) ) { %> 									
			
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	
					<td  width=3% align="center">&nbsp;</td>	
   <% } else { %>   
   					<td  width=3% align="right"><%= ht.get("REMAIN") %>&nbsp;</td>	 
					<td  width=3% align="right"><%= ht.get("IWOL_SU") %>&nbsp;</td>	 
					<td  width=3% align="right"><%= AddUtil.parseDouble((String)ht.get("REMAIN"))-AddUtil.parseDouble((String)ht.get("IWOL_SU")) %>&nbsp;</td>	 
	    			<td  width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("DUE_DT")) %></td>	 
    <% }  %>  
 <% }  %>
 					<td width=6% align="center">
						<%if(b_su >= 3){%>
						<font color = 'red'><b>
						<%=AddUtil.parseInt((String)ht3.get("B1"))%> : <%=AddUtil.parseInt((String)ht3.get("B2"))%>
						</font></b>
						<%}else{%>
						<%=AddUtil.parseInt((String)ht3.get("B1"))%> : <%=AddUtil.parseInt((String)ht3.get("B2"))%>
						<%}%>
					</td> 
 					<td width=4% align="center"><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %><font style="color:red;"><% } %><%= ht.get("OV_CNT") %><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %></font><% } %></td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td></td>
    </tr>
    
    <tr> 
        <td><p>※ 유의사항<br>
            1. 사용기한(근로기준법기준) 3개월 이전 현재까지 남아있는 미사용 연차는 사용계획서를 총무팀에 제출 바랍니다.<br>							
            2. 사용기한(근로기준법기준) 2개월 이전 현재까지 사용계획서를 제출하지 않은 미사용 연차는 회사가 사용예정일을 정하여 통보할 수 있습니다.<br>													

          </p>
        </td>
    </tr>
   
    <tr> 
        <td><font color="#999999">♣ 연차의 발생 및 소멸은 입사일이 기준일입니다. 따라서 새로운 연차는 본인의 입사일에 계속근무기간에 따른 가산일수가 더해져 발생합니다.</font></td>
    </tr>
     
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>연차사용내역</span></td>
    </tr>
</table>


<table  width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table  width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" rowspan=2 width=8%>연번</td>
                    <td class="title" width=14%  colspan=2>구분</td> <!-- 이월이 있는 경우 30일까지 가능 -->
                    <td class="title" rowspan=2 width=8%>급여</td>
                    <td class="title" rowspan=2 width=11%>사용일자</td>
                    <td class="title" rowspan=2 width=8%>요일</td>
                    <td class="title" rowspan=2 width=11%>등록일자</td>
                    <td class="title" rowspan=2 width=40%>적요</td>
                </tr>
                 <tr> 
                    <td class="title" width=7%>발생</td>
                    <td class="title" width=7%>사용</td>                  
                </tr>
                
                <% if(vt.size()>0){
        			 for(int i=0; i< vt.size(); i++){
        				Hashtable sch = (Hashtable)vt.elementAt(i);	
        			        			        				
        				use_dt= String.valueOf(sch.get("START_YEAR"))+String.valueOf(sch.get("START_MON"))+String.valueOf(sch.get("START_DAY"));
        				        			
        	  %>
                <tr> 
                    <td align="center"><%= i+1 %></td>   
                    <td align="center"><%if( sch.get("IWOL").equals("Y")){%>이월 <%} else {%>신규<%}%></td>  
                    <td align="center">
                    <%if( sch.get("COUNT").equals("B1")){%>반휴 <%} else if ( sch.get("COUNT").equals("B2")){%>반휴 <%} else {%>연차<%}%> </td>    
                    <td align="center"><%if( sch.get("OV_YN").equals("Y")){%>무급<%}else{%>유급<%}%></td>
                    <td align="center"><%= AddUtil.ChangeDate2(use_dt) %></td>
                    <td align="center"><%= sch.get("DAY_NM") %></td> 
                    <td align="center"><%= AddUtil.ChangeDate2((String)sch.get("REG_DT")) %></td>
                    <td align="left">&nbsp;<%= sch.get("TITLE") %> - <%= sch.get("CONTENT") %>
                    <% if (ck_acar_id.equals("000063")) { %>
                       <a href="javascript:sch_d( '<%=user_id%>', '<%=sch.get("START_YEAR")%>', '<%=sch.get("START_MON")%>', '<%=sch.get("START_DAY")%>',  '<%=sch.get("SEQ")%>');">D</a>
                    <% }  %>
                    </td>
                </tr>
                <% 	}%>
				
        		  <%}else{ %>
                <tr> 
                    <td colspan="8" align="center">사용내역이 없습니다.</td>
                </tr>
                <% } %>
				
            </table>
        </td>
    </tr>
    
	<tr>
        <td>&nbsp;</td>
    </tr>
     
    <tr> 
        <td><div align="left"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>연차 운용 규정</span></div></td>
    </tr>
     <tr> 
        <td>
          <p> 1. 월차휴가 : 휴가제도 없음<br>
            2. 생리휴가 : 무급휴가(여성 사원이 요청한 경우에 한함)<br>
            3. 연차휴가 :<br>
            &nbsp;&nbsp;&nbsp;1) 입사 1년차 : 최대 11일 (개정:2017-12-28, 적용:2018-05-29)<br>
            &nbsp;&nbsp;&nbsp;2) 최초 1년 계속 근로한 자 : 15일<br>
            &nbsp;&nbsp;&nbsp;3) 3년이상 계속 근로한 자 : 최초 1년을 초과하여 계속 근로연수. 매2년에 대하여 1일을 
            가산하여 줌(25일을 한도로 함)<br>
            &nbsp;&nbsp;&nbsp;4) 휴가는 1년간 행사하지 아니한 때에는 소멸되며, 미사용 휴가에 대하여는 보상하지 않음<br>
            &nbsp;&nbsp;&nbsp;5) 하기휴가는 연차휴가일수에 포함함 (단, 장기근속사원 포상휴가 및 경조사 휴가는 포함하지 않음)<br>
             &nbsp;&nbsp;&nbsp;6) 미사용연차는 소멸일(근로기준법 준용)부터 30일내 이월해서 사용가능(근로기준법외 사내규정, 시행:2021-12-08)<br>	 						
   			4. 반휴가 : (근로기준법외 사내규정, 개정/시행:2021-12-08)<br>
            &nbsp;&nbsp;&nbsp;1) 오전.오후를 매칭하면서 사용<br>
            &nbsp;&nbsp;&nbsp;2) 연속2회 이상 오전.오후를 상충해서는 등록 및 사용불가<br>
            &nbsp;&nbsp;&nbsp;3) 종일근무 중식대의 50%내 지급<br>
               
            &nbsp;&nbsp;&nbsp;<!--6) 예외규정 : 육아휴직 이후 복직한 당해(본인 입사일자 기준)에 발생한 연차(또는 사용 후 남은 연차)는 익년(본인 입사일자 기준)까지 1년간 한정해 나누어 사용할 수 있다.<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (단,산전후휴가와 연속하여 육아휴직을 사용한 여성사원에 한정) (개정 2016년10월19일) <적용일자 : 2016년은 소급적용><br>-->
          </p>
        <!--   <p>&nbsp;&nbsp;<적용일자 : 2009년 4월 17일></p>-->
        </td>
      </tr>
</table>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

</form>
</body>
</html>
