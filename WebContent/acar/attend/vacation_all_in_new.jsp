<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.attend.* "%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
	String user_id =request.getParameter("user_id")==null?"":request.getParameter("user_id");	

	VacationDatabase v_db = VacationDatabase.getInstance();
	Vector vt = v_db.getVacationAll2_new(br_id, dept_id, user_nm);
	
	int year = 0, cnt = 0;
	int b_su = 0;
	long total_days = 0;
	long man_days = 0;
	long women_days = 0;
	long outside_days = 0;
	long inside_days = 0;
	int man_cnt = 0;
	int women_cnt = 0;
	int outside_cnt = 0;
	int inside_cnt = 0;
	String jumin = "";
	String gender = "";
	
	for(int i=0; i< vt.size(); i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);	 
		total_days += Integer.parseInt(String.valueOf(ht.get("T_DAYS")));
		jumin = String.valueOf(ht.get("USER_SSN"));
		gender = jumin.substring(6,7);
		if(gender.equals("1")){	//남자 직원
			man_cnt ++; 
			man_days += Integer.parseInt(String.valueOf(ht.get("T_DAYS")));	
		}
		if(gender.equals("2")){	//여자 직원
			women_cnt ++; 
			women_days += Integer.parseInt(String.valueOf(ht.get("T_DAYS")));	
		}
		if(ht.get("LOAN_ST").equals("1")||ht.get("LOAN_ST").equals("2")){	//외근직
			outside_cnt ++; 
			outside_days += Integer.parseInt(String.valueOf(ht.get("T_DAYS")));
		}
		if(ht.get("LOAN_ST").equals("")){	//내근직
			inside_cnt ++; 
			inside_days += Integer.parseInt(String.valueOf(ht.get("T_DAYS")));
		}
	}
	
	float f_ca_days =  0;
	float m_ca_days = 0;
	float w_ca_days =  0;
	float o_ca_days =  0;
	float i_ca_days =  0;
	
	int ca_days = 0;
	
	//계속근무기간(평균구하기)
    Hashtable ht1 =   new Hashtable();		//전체 평균
    Hashtable ht4 =   new Hashtable();		//남자직원 평균
    Hashtable ht5 =   new Hashtable();		//여자직원 평균
	Hashtable ht6 =   new Hashtable();		//내근직원 평균
    Hashtable ht7 =   new Hashtable();		//외근직원 평균
    
    //20200529 cnt 값이 0일 경우 나누기시 결과는0이므로 일수 0처리
	if ( vt.size() >= 1 ) {
	
		f_ca_days =  total_days / vt.size();
		if (man_cnt <= 0) {
			m_ca_days = 0;
		} else {
			m_ca_days =  man_days / man_cnt;
		}
		if (women_cnt <= 0) {
			w_ca_days = 0;
		} else {
			w_ca_days = women_days / women_cnt;
		}
		if (outside_cnt <= 0) {
			o_ca_days = 0;
		} else {
			o_ca_days = outside_days / outside_cnt;
		}
		if (inside_cnt <= 0) {
			i_ca_days = 0;
		} else {
			i_ca_days = inside_days / inside_cnt;
		}
		
		ca_days = ( int) f_ca_days;
		
		//계속근무기간(평균구하기)
	    ht1 =   v_db.getReturnYMD(ca_days);			//전체 평균
	    ht4 =   v_db.getReturnYMD((int)m_ca_days);	//남자직원 평균
	    ht5 =   v_db.getReturnYMD((int)w_ca_days);	//여자직원 평균
		ht6 =   v_db.getReturnYMD((int)o_ca_days);	//내근직원 평균
	    ht7 =   v_db.getReturnYMD((int)i_ca_days);	//외근직원 평균
	} 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}
//-->	
</script>
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <% if(vt.size()>0){
			 for(int i=0; i< vt.size(); i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				year = AddUtil.parseInt((String)ht.get("YEAR"));
				user_id = (String)ht.get("USER_ID");
				Hashtable ht2 = v_db.getVacationBan(user_id);
				Hashtable ht3 = v_db.getVacationBan2(user_id);
				
				b_su = AddUtil.parseInt((String)ht3.get("B2")) - AddUtil.parseInt((String)ht3.get("B1"));
				b_su = Math.abs(b_su);
				
				if(year > 0){
					cnt++;
			  %>
                <tr> 
                    <td width=3% align="center"><%= cnt %></td>
                    <td width=8% align="center"><%= ht.get("BR_NM") %></td>
                    <td width=8% align="center"><%= ht.get("DEPT_NM") %></td>
                    <td width=5% align="center"><%= ht.get("USER_POS") %></td>
                    <td width=7% align="center"><%= ht.get("USER_NM") %>
                <!--    <a href="javascript:MM_openBrWindow('vacation_force_view.jsp?auth_rw=1&user_id=<%= ht.get("USER_ID") %>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=460,height=400,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="미사용연차통보내역보기"></a>&nbsp;-->
                    </td>
                    <td width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("ENTER_DT")) %></td>
                    <td width=4% align="center"><%= ht.get("YEAR") %></td>
                    <td width=4% align="center"><%= ht.get("MONTH") %></td>
                    <td width=4% align="center"><%= ht.get("DAY") %></td> 
                    <td width=4% align="right"><b><%if( ck_acar_id.equals("000063")){%><a  href="javascript:MM_openBrWindow('vacation_cnt.jsp?auth_rw=1&user_id=<%= ht.get("USER_ID") %>','Vacation','scrollbars=no,status=yes,resizable=yes,width=520,height=150,left=50, top=50')">
					<%= ht.get("VACATION") %></a><%}else{%><%= ht.get("VACATION") %><%}%></b>&nbsp;&nbsp;</td>
                    <td width=5% align="right"><font style="color:red;"><b><%if(ht.get("SU").equals("")){%>0<%}else{%><%= ht.get("SU") %><%}%></b></font>
        		  	<a href="javascript:MM_openBrWindow('vacation_sc_in_new.jsp?auth_rw=1&user_id=<%= ht.get("USER_ID") %>&br_id=<%= ht.get("BR_ID") %>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=1300,height=700,top=20,left=20')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>&nbsp;</td>
                    <td width=5% align="right"><font style="color:blue;"><b><%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("OV_CNT")) %></b></font></td>
                 	<td width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("END_DT")) %></td>
                	
<% if ( AddUtil.parseInt(String.valueOf(ht.get("D_90_DT")))   <= AddUtil.parseInt(String.valueOf(ht.get("TODAY"))) ) { %> 		
					<td  width=4% align="center">&nbsp;</td>	 
					<td  width=4% align="center">&nbsp;</td>	 
					<td  width=4% align="center">&nbsp;</td>	
	    			<td  width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("C_DUE_DT")) %></td>	

<% } else {  %>					
					
	<% if ( String.valueOf(ht.get("REMAIN")).equals("") || String.valueOf(ht.get("REMAIN")).equals("0")  || AddUtil.parseInt(String.valueOf(ht.get("DUE_DT")))  <= AddUtil.parseInt(String.valueOf(ht.get("TODAY"))) ) { %> 					
					<td  width=4% align="center">&nbsp;</td>	 
					<td  width=4% align="center">&nbsp;</td>	 
					<td  width=4% align="center">&nbsp;</td>	
					<td  width=7% align="center">&nbsp;</td>	
   <% } else { %>   
   					<td  width=4% align="right"><%= ht.get("REMAIN") %>&nbsp;</td>	 
					<td  width=4% align="right"><%= ht.get("IWOL_SU") %>&nbsp;</td>	 
					<td  width=4% align="right"><%= AddUtil.parseDouble((String)ht.get("REMAIN"))-AddUtil.parseDouble((String)ht.get("IWOL_SU")) %>&nbsp;</td>	 
	    			<td  width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("DUE_DT")) %></td>	 
    <% }  %>  
 <% }%>    
    				<td width=6% align="center">
						<%if(b_su >= 3){%>
						<font color = 'red'><b>
						<%=AddUtil.parseInt((String)ht3.get("B1"))%> : <%=AddUtil.parseInt((String)ht3.get("B2"))%>
						</font></b>
						<%}else{%>
						<%=AddUtil.parseInt((String)ht3.get("B1"))%> : <%=AddUtil.parseInt((String)ht3.get("B2"))%>
						<%}%>
					</td>
    			    <td width=4% align="center"><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %><font style="color:red;"><% } %><%= ht.get("OV_CNT") %><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %></font><% } %>&nbsp;</td>	 

                </tr>
          <% 		}
    	} %>       
        			 			
        	  	<tr>        			
                    <td colspan="21" class=title_p>- 입사 1년 미만 -</td>
        		</tr>
      		
        <%for (int i = 0; i < vt.size(); i++) {
				Hashtable ht = (Hashtable)vt.elementAt(i);
				year = AddUtil.parseInt((String)ht.get("YEAR"));
				user_id = (String)ht.get("USER_ID");
				Hashtable ht2 = v_db.getVacationBan(user_id);
				Hashtable ht3 = v_db.getVacationBan2(user_id);
				b_su = AddUtil.parseInt((String)ht3.get("B2")) - AddUtil.parseInt((String)ht3.get("B1"));
				b_su = Math.abs(b_su);
				if (year == 0) {
					cnt++;
			  %>
        		
                <tr> 
                    <td  width=3% align="center"><%= cnt %></td>
                    <td  width=8% align="center"><%= ht.get("BR_NM") %></td>
                    <td  width=8% align="center"><%= ht.get("DEPT_NM") %></td>
                    <td  width=5% align="center"><%= ht.get("USER_POS") %></td>
                    <td  width=7% align="center"><%= ht.get("USER_NM") %></td>
                    <td width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("ENTER_DT")) %></td>
                    <td width=4% align="center"><%= ht.get("YEAR") %></td>
                    <td width=4% align="center"><%= ht.get("MONTH") %></td>
                    <td width=4% align="center"><%= ht.get("DAY") %></td>
                    <td width=4% align="right"><b><%if( ck_acar_id.equals("000096")){%><a  href="javascript:MM_openBrWindow('vacation_cnt.jsp?auth_rw=1&user_id=<%= ht.get("USER_ID") %>','Vacation','scrollbars=no,status=yes,resizable=yes,width=520,height=150,left=50, top=50')">
					<%= ht.get("VACATION") %></a><%}else{%><%= ht.get("VACATION") %><%}%></b>&nbsp;</td>
                    <td width=5% align="right"><font style="color:red;"><b><%= ht.get("SU") %></b></font>
		  			<a href="javascript:MM_openBrWindow('vacation_sc_in_new.jsp?auth_rw=1&user_id=<%= ht.get("USER_ID") %>&br_id=<%= ht.get("BR_ID") %>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=1300,height=700,top=20,left=20')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>&nbsp;</td>
                    <td width=5% align="right"><font style="color:blue;"><b><%= AddUtil.parseDouble((String)ht.get("VACATION"))+AddUtil.parseDouble((String)ht.get("OV_CNT"))-AddUtil.parseDouble((String)ht.get("SU")) %></b></font>&nbsp;</td>
             	    <td width=7% align="center">&nbsp;</td>          
					<td width=4% align="center">&nbsp;</td>
					<td width=4% align="center">&nbsp;</td>
					<td width=4% align="center">&nbsp;</td>
					<td width=7% align="center">&nbsp;</td>
					<td width=6% align="center">
					<%if(b_su >= 3){%>
						<font color = 'red'><b>
						<%=AddUtil.parseInt((String)ht3.get("B1"))%> : <%=AddUtil.parseInt((String)ht3.get("B2"))%>
						</font></b>
						<%}else{%>
						<%=AddUtil.parseInt((String)ht3.get("B1"))%> : <%=AddUtil.parseInt((String)ht3.get("B2"))%>
						<%}%>
					</td>
					<td width=4% align="center"><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %><font style="color:red;"><% } %><%= ht.get("OV_CNT") %><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %></font><% } %>&nbsp;</td>
							
                </tr>
        <% 		}
			}	%>	
		
	    
		<% if ( vt.size() > 1 ) { %>		
				<tr>               
                    <td colspan="22" class="line">
                    	<table width="100%" border="0" cellspacing="1" cellpadding="0">
                    		<tr>
                    			<td class="title" width="*">계속근무기간</td>
                    			<td class="title" width="7%">전체 평균</td>
                    			<td align="right" width="3.5%"><%=ht1.get("YY")%> 년</td>
                    			<td align="right" width="3.5%"><%=ht1.get("MM")%> 월</td>
                    			<td align="right" width="3.5%"><%=ht1.get("DD")%> 일</td>
                    			<td class="title" width="7%">남자직원 평균</td>
                    			<td align="right" width="3.5%"><%=ht4.get("YY")%> 년</td>
                    			<td align="right" width="3.5%"><%=ht4.get("MM")%> 월</td>
                    			<td align="right" width="3.5%"><%=ht4.get("DD")%> 일</td>
                    			<td class="title" width="7%">여자직원 평균</td>
                    			<td align="right" width="3.5%"><%=ht5.get("YY")%> 년</td>
                    			<td align="right" width="3.5%"><%=ht5.get("MM")%> 월</td>
                    			<td align="right" width="3.5%"><%=ht5.get("DD")%> 일</td>
                    			<td class="title" width="7%">외근직 평균</td>
                    			<td align="right" width="3.5%"><%=ht6.get("YY")%> 년</td>
                    			<td align="right" width="3.5%"><%=ht6.get("MM")%> 월</td>
                    			<td align="right" width="3.5%"><%=ht6.get("DD")%> 일</td>
                    			<td class="title" width="7%">내근직 평균</td>
                    			<td align="right" width="3.5%"><%=ht7.get("YY")%> 년</td>
                    			<td align="right" width="3.5%"><%=ht7.get("MM")%> 월</td>
                    			<td align="right" width="3.5%"><%=ht7.get("DD")%> 일</td>
                    			
                    			
                    		</tr>
                    	</table>
                    </td>
                </tr>	
		<% } %>	
	<%	  }else{ %>
                <tr> 
                    <td colspan="21" align="center">해당 데이터가 없습니다.</td>
                </tr>
        <% } %>
     
            </table>
        </td>
    </tr>
</table>
</body>
</html>
