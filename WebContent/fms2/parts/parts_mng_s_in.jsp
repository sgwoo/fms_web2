<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.parts.*"%>
<jsp:useBean id="p_db" scope="page" class="acar.parts.PartsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	
	function set_tot_amt(){
		fm = document.form1;
	
		parent.form1.m_sum.value =parseDecimal(toInt(parseDigit(fm.m_sum.value)));  //명진	
		parent.form1.o_sum.value =parseDecimal(toInt(parseDigit(fm.o_sum.value)));  //오토크린	
		parent.form1.t_sum.value = parseDecimal(toInt(parseDigit(fm.t_sum.value)));  //total	
		
		parent.form1.m_l_sum.value =parseDecimal(toInt(parseDigit(fm.m_l_sum.value)));  //명진	
		parent.form1.o_l_sum.value =parseDecimal(toInt(parseDigit(fm.o_l_sum.value)));  //오토크린	
		parent.form1.t_l_sum.value = parseDecimal(toInt(parseDigit(fm.t_l_sum.value)));  //total	
		
	
	}
			
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
		
	Vector vt =  p_db.getPartsOrderItemList(s_kd, t_wd, st_dt, end_dt,  gubun2, gubun3);	
	int vt_size = vt.size();
	
	 int m_qty = 0; 
	 int m_r_amt = 0;
	 int o_qty = 0; 
	 int o_r_amt = 0; 
	 int t_qty= 0; 
	 int t_r_amt= 0;                         
	 int m_l_qty = 0; 
	 int m_l_r_amt = 0;
	 int o_l_qty = 0; 
	 int o_l_r_amt = 0; 
	 int t_l_qty= 0; 
	 int t_l_r_amt= 0;                         
	 
	 int m_sum = 0; 
	 int o_sum= 0; 
	 int t_sum= 0;                         					 
	
	 int m_l_sum = 0; 
	 int o_l_sum= 0; 
	 int t_l_sum= 0;                         			
	 
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>

<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
 	  <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='1000'>
	       <tr> 
                            <td width='60' class='title' rowspan=3>연번</td>
                            <td width='100' class='title' rowspan=3>부품번호</td>
                            <td width='200' class='title' rowspan=3>부품명</td>
                            <td  class='title' colspan=6>구매</td>
                            <td  class='title' colspan=6>LOCATION</td>
                                                 
                  </tr>
                    <tr> 
                            <td class='title' colspan=2>명진</td>
                            <td class='title' colspan=2>오토크린</td>
                            <td class='title' colspan=2>합계</td>
                            <td class='title' colspan=2>명진</td>
                            <td class='title' colspan=2>오토크린</td>
                            <td class='title' colspan=2>합계</td>
                   </tr>
                  <tr> 
                            <td width='30' class='title' >수량</td>
                            <td width='75' class='title' >금액</td>
                            <td width='30' class='title' >수량</td>
                            <td width='75' class='title'>금액</td>
                            <td width='30' class='title'>수량</td>
                            <td width='80' class='title'>금액</td>
                            <td width='30' class='title' >수량</td>
                            <td width='75' class='title' >금액</td>
                            <td width='30' class='title' >수량</td>
                            <td width='75' class='title'>금액</td>
                             <td width='30' class='title'>수량</td>
                            <td width='80' class='title'>금액</td>
                   </tr>
            </table>
        </td>
    </tr>     
    <tr>
         	  <td class='line' width='1000' > 
         	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            	    
     <%	if(vt_size > 0){%>
      
                          <% 	for (int i = 0 ; i < vt_size ; i++){
                        				Hashtable ht = (Hashtable)vt.elementAt(i);
                        				
                        					 m_qty = m_qty + AddUtil.parseInt((String)ht.get("M_QTY")); 
                        					 m_r_amt = m_r_amt + AddUtil.parseInt((String)ht.get("M_R_AMT"));
                        					 o_qty = o_qty + AddUtil.parseInt((String)ht.get("O_QTY")); 
                        					 o_r_amt = o_r_amt +  AddUtil.parseInt((String)ht.get("O_R_AMT")); 
                        					 m_l_qty = m_l_qty + AddUtil.parseInt((String)ht.get("M_L_QTY")); 
                        					 m_l_r_amt = m_l_r_amt + AddUtil.parseInt((String)ht.get("M_L_R_AMT"));
                        					 o_l_qty = o_l_qty + AddUtil.parseInt((String)ht.get("O_L_QTY")); 
                        					 o_l_r_amt = o_l_r_amt +  AddUtil.parseInt((String)ht.get("O_L_R_AMT"));                         				
                        %>
           
                      <tr> 
                               <td  width='60' align='center'><%=i+1%></td>
                               <td width='100'  align="center"><%=ht.get("PARTS_NO")%></td>		
		            <td width='200' align="center"><%=ht.get("PARTS_NM")%></td>			
		            <td width='30' align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("M_QTY")))%></td>			
		            <td width='75'  align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("M_R_AMT")))%></td>			
		            <td width='30'  align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_QTY")))%></td>			
		            <td width='75'   align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_R_AMT")))%></td>		
		             <td width='30' align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("T_QTY")))%></td>		
		             <td width='80'   align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("T_R_AMT")))%></td>			                           
		             <td width='30' align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("M_L_QTY")))%></td>			
		            <td width='75'  align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("M_L_R_AMT")))%></td>			
		            <td width='30'  align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_L_QTY")))%></td>			
		            <td width='75'   align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_L_R_AMT")))%></td>		
		             <td width='30' align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("T_L_QTY")))%></td>		
		             <td width='80'   align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("T_L_R_AMT")))%></td>			                            
               
         		   </tr>
                <%		}%> 		
   		   
   		     <tr> 
                                <td colspan="3" class='title'>합 계&nbsp;(공급가)</td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(m_qty) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(m_r_amt) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(o_qty) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(o_r_amt) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(m_qty+ o_qty) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(m_r_amt + o_r_amt) %></td>
                               <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(m_l_qty) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(m_l_r_amt) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(o_l_qty) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(o_l_r_amt) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(m_l_qty+ o_l_qty) %></td>
                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(m_l_r_amt + o_l_r_amt) %></td>
                                                     
                        </tr>
                            
         		  </table>
         		</td>

<%	}else{%>                   
      
                      <tr> 
                        <td align='center'>등록된 데이타가 없습니다</td>
                      </tr>
                    </table></td>
  
   <% }%>          
 </tr>
     <input type="hidden" name="m_sum"  size="10" value="<%= AddUtil.parseDecimal(m_r_amt*10/100) %>" > 
     <input type="hidden" name="o_sum" size="10" value="<%= AddUtil.parseDecimal(o_r_amt*10/100) %>" > 
     <input type="hidden" name="t_sum"  size="10" value="<%= AddUtil.parseDecimal( (m_r_amt*10/100) + (o_r_amt*10/100) ) %>" > 
      <input type="hidden" name="m_l_sum"  size="10" value="<%= AddUtil.parseDecimal(m_l_r_amt*10/100) %>" > 
     <input type="hidden" name="o_l_sum" size="10" value="<%= AddUtil.parseDecimal(o_l_r_amt*10/100) %>" > 
     <input type="hidden" name="t_l_sum"  size="10" value="<%= AddUtil.parseDecimal( (m_l_r_amt*10/100) + (o_l_r_amt*10/100) ) %>" > 
             	  	
</table>
<%if(vt_size >0){%>
<script language="JavaScript">
	set_tot_amt()
</script>
<% } %>
 </td>
    </tr>
</table>
</form>
</body>
</html>

