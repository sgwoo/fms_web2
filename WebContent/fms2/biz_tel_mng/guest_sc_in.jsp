<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	
	String cmd = "";
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	if(!gubun4.equals("3")){
		s_dt = "";
		e_dt = "";
	}
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	//공통변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstiSpeBean [] e_r = e_db.getEstiGuestList(gubun1, gubun2, gubun3, gubun4, s_dt, e_dt, s_kd, t_wd, esti_m, esti_m_dt, esti_m_s_dt, esti_m_e_dt);
	int size = e_r.length;
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function EstiMemo(est_id, user_id, chk, bb_chk, t_chk){
	   
	   	var fm = document.form1;
	   	  
		var SUBWIN="./guest_memo_spe_i.jsp?t_chk="+t_chk+"&bb_chk="+bb_chk+"&chk="+chk+"&est_id="+est_id+"&user_id="+user_id;	
		window.open(SUBWIN, "EstiMemoSpeDisp", "left=25, top=25, width=650, height=700, resizable=yes, scrollbars=yes, status=yes");
	
		<%if(!nm_db.getWorkAuthUser("전산팀",user_id)){%>		
		onload(est_id, user_id);
		<%}%>
	}
	
	function onload(est_id, user_id){

		var fm = document.form1;
		fm.cmd.value = "s";
		fm.target = "i_no";
		fm.action="guest_memo_null_ui2.jsp?est_id="+est_id+"&user_id="+user_id;
		fm.submit();
	}
//-->
</script>

</head>
<body onLoad="">
<form action="" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">  
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">          
  <input type="hidden" name="t_wd" value="<%=t_wd%>"> 
  <input type="hidden" name="esti_m" value="<%=esti_m%>"> 
  <input type="hidden" name="esti_m_dt" value="<%=esti_m_dt%>"> 
  <input type="hidden" name="esti_m_s_dt" value="<%=esti_m_s_dt%>"> 
  <input type="hidden" name="esti_m_e_dt" value="<%=esti_m_e_dt%>">         
  <input type="hidden" name="est_id" value="">    
  <input type="hidden" name="cmd" value="">    
  <input type="hidden" name="t_user_id" value="<%=bean.getT_user_id()%>">         
<table border=0 cellspacing=0 cellpadding=0 width=1500>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' > 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=4%  class=title>연번</td>
                    <td width=14% class=title>통화</td>     
                    <td width=9% class=title>상담결과</td>                 
                    <td width=10% class=title>신청일자</td>
                    <td width=5% class=title>작성지역</td>
                    <td width=14% class=title>성명/법인명</td>
                    <td width=8%  class=title>담당자</td>
                    <td width=9% class=title>전화번호</td>
                    <td width=9%  class=title>작성자</td>
                    <td width=18% class=title>기타요청사항</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class='line'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <%for(int i=0; i<size; i++){
    					bean = e_r[i]; 					

						UsersBean user_bean = umd.getUsersBean(bean.getReg_id());
			  %> 
                <tr> 
                    <td width=4%  align="center"><%=size-i%></td>                  
                    <td width=14% align="center">
        			<%if(bean.getM_reg_dt().equals("") && bean.getB_reg_dt().equals("")  && bean.getT_reg_dt().equals("") && bean.getB_note().equals("")){ %>        
        			  	 <a href="javascript:EstiMemo('<%=bean.getEst_id()%>','<%=user_id%>', '1', '', '')">통화</a>

						<%}else{%>
        			  	 <a href="javascript:EstiMemo('<%=bean.getEst_id()%>','<%=user_id%>', '2', '<%=bean.getB_reg_dt()%>', '<%=bean.getT_reg_dt()%>' )">
						 
        			  	<!-- 통화거나 부재중이거나 결번이거나  -->
        			  	<% if  ( !bean.getT_reg_dt().equals("") ) {%>
	        			  	 <%=AddUtil.ChangeDate6(bean.getT_reg_dt())%> 
			        		 <%=c_db.getNameById(bean.getT_user_id(), "USER_DE")%> <%if(bean.getM_user_id().equals("")){%><%=c_db.getNameById(bean.getT_user_id(), "USER")%><%}else{%><%=c_db.getNameById(bean.getM_user_id(), "USER")%><%}%>
		        		<% } else { %>
							<%if( !bean.getB_note().equals("") && bean.getM_reg_dt().equals("") ) {%>
								<%=AddUtil.ChangeDate6(bean.getB_reg_dt())%> <%=bean.getB_note()%>
							<% } %> 
		        		<% } %> 
		        		 </a>
        			  <%}%>
        			</td>       
        		    <td width=9% align="center">
        		    <% if ( !bean.getB_note().equals("")) { %>
		        			    <%=bean.getB_note()%>
					<%}else{%>
							<%=bean.getRent_yn()%> 
					<%}%>
        		    </td>	 		
                    <td width=10% align="center"><%= AddUtil.ChangeDate3(bean.getReg_dt())%></td>	
                   	<td width=5% align="center"><%=c_db.getNameById(user_bean.getUser_id(), "USER_BR")%> </td>			
                    <td width=14% align="center"><%=AddUtil.subData(bean.getEst_nm(), 10)%></td>
                    <td width=8%  align="center"><%=AddUtil.subData(bean.getEst_agnt(), 6)%></td>
                    <td width=9% align="center"><%=bean.getEst_tel()%></td>                   
                    <td width=9% align="center"><%=c_db.getNameById(user_bean.getUser_id(), "USER_DE")%> <%=user_bean.getUser_nm()%></td>
                    <td width=18%>&nbsp;<span title='<%=bean.getEtc()%>'><%=AddUtil.subData(bean.getEtc(), 15)%></span></td>
                </tr>
              <%}%>
              <% if(size == 0) { %>
                <tr> 
                    <td align=center>&nbsp;</td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
