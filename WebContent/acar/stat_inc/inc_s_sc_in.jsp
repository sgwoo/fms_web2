<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.stat_inc.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function IncPop(st, gubun, pay_st, m_id, l_cd, c_id, rent_st, tm, seq_no){
		var fm = document.form1;	
		var height = "180";
		if(gubun == "�뿩��" && pay_st == "�̼���") height = "400";
		var SUBWIN="inc_pop.jsp?auth_rw=" + fm.auth_rw.value 
					+ "&user_id=" + fm.user_id.value
					+ "&st=" + st
					+ "&gubun=" + gubun
					+ "&pay_st=" + pay_st					
					+ "&m_id=" + m_id
					+ "&l_cd=" + l_cd
					+ "&c_id=" + c_id 
					+ "&rent_st=" + rent_st
					+ "&tm=" + tm
					+ "&seq_no=" + seq_no; 
		window.open(SUBWIN, "IncPop", "left=100, top=100, width=660, height="+height+", scrollbars=yes");
	}

	function IncLoad(){
		var fm = document.form1;
		fm.submit();
	}
	
/* Title ���� */
	function init() {	
		setupEvents();
	}	
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	function moveTitle(){
	    var X ;
    	document.all.title.style.pixelTop = document.body.scrollTop ;                                                                              
	    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    	document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;       
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	StatIncDatabase sid = StatIncDatabase.getInstance();
	Vector s_ins = sid.getStatIncList(br_id, gubun1, gubun2, gubun3, st_dt, end_dt);
	int s_in_size = s_ins.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width=1300>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
                <tr id='title' style='position:relative;z-index:1'>
                    <td width=55% class=line id='title_col0' style='position:relative;'>
                        <table border=0 cellspacing=1 width=100%>
                            <tr>
                				<td width=8% class=title>����</td>
                				<td width=11% class=title>����</td>
                			    <td width=16% class=title>����ȣ</td>
                			    <td width=19% class='title'>��ȣ</td>
                				<td width=12% class='title'>����</td>
                				<td width=16% class='title'>������ȣ</td>
                				<td width=18% class='title'>����</td>
            			    </tr>
			            </table>
		            </td>
		            <td class=line width=45%>
            			<table  border=0 cellspacing=1 width=100%>
            			    <tr>            
                				<td width=15% class='title'>���α���</td>
                				<td width=16% class='title'>�Աݿ�����</td>
                				<td width=17% class='title'>���ް�</td>
                				<td width=16% class='title'>�ΰ���</td>
                				<td width=17% class='title'>�ݾ�</td>
                				<td width=16% class='title'>������</td>
            			    </tr>
            			</table>
		            </td>
		        </tr>
<% if(s_in_size != 0){ %>
       	        <tr>
                    <td width=55% class=line id='D1_col' style='position:relative;'>
                        <table border=0 cellspacing=1 width=100%>
            <% 		for (int i = 0 ; i < s_in_size ; i++){
            			Hashtable s_in = (Hashtable)s_ins.elementAt(i);%>
                            <tr>
                            	<td width=8% align="center"><%=i+1%></td>
                            	<td width=11% align="center"><%=s_in.get("GUBUN")%></td>
                            	<td width=16% align="center"><%=s_in.get("RENT_L_CD")%></td>
                            	<td width=19% align="left">&nbsp;<span title="<%=s_in.get("FIRM_NM")%>"><%=Util.subData((String)s_in.get("FIRM_NM"),8)%></span></td>
                            	<td width=12% align="center"><span title="<%=s_in.get("CLIENT_NM")%>"><%=Util.subData((String)s_in.get("CLIENT_NM"),5)%></span></td>
                            	<td width=16% align="center"><%=s_in.get("CAR_NO")%></td>
                        	    <td width=18%>&nbsp;<span title="<%=s_in.get("CAR_NM")%> <%=s_in.get("CAR_NAME")%>"><%=Util.subData((String)s_in.get("CAR_NM")+" "+(String)s_in.get("CAR_NAME"),9)%></span></td>				
            	            </tr>
            <%		}%>
                            <tr>
                                <td class="title" align='center'></td>
                			    <td class="title">&nbsp;</td>
                                <td class="title">&nbsp;</td>
                                <td class="title" align='center'>�հ�</td>
                                <td class="title">&nbsp;</td>
                                <td class="title">&nbsp;</td>
                                <td class="title">&nbsp;</td>
                            </tr>			
            			</table>
            	    </td>            		            		
                    <td class=line width=45%>
                        <table border=0 cellspacing=1 width=100%>
            <% 		for (int i = 0 ; i < s_in_size ; i++){
            			Hashtable s_in = (Hashtable)s_ins.elementAt(i);
            			String pay_st = (String)s_in.get("PAY_ST");
            			String gubun = (String)s_in.get("GUBUN");%>
                            <tr>
                            	<td width=15% align="center"><%=s_in.get("TM")%></td>
                            	<td width=16% align="center"><%if(gubun.equals("�뿩��")){%><%=s_in.get("I_EST_DT")%><%}else{%><%=s_in.get("EST_DT")%><%}%></td>
                            	<td width=17% align="right"><%=Util.parseDecimal((String)s_in.get("S_AMT"))%>��&nbsp;</td>
                            	<td width=16% align="right"><%=Util.parseDecimal((String)s_in.get("V_AMT"))%>��&nbsp;</td>
                            	<td width=17% align="right"><%=Util.parseDecimal((String)s_in.get("AMT"))%>��&nbsp;</td>
                            	<td width=16% align="center"><!--<a href="javascript:IncPop('<%=s_in.get("ST")%>','<%=s_in.get("GUBUN")%>','<%=s_in.get("PAY_ST")%>','<%=s_in.get("RENT_MNG_ID")%>','<%=s_in.get("RENT_L_CD")%>','<%=s_in.get("CAR_MNG_ID")%>','<%=s_in.get("RENT_ST")%>','<%=s_in.get("TM")%>','<%=s_in.get("SEQ_NO")%>');">-->
                				<%if(pay_st.equals("����")){%>
                				  	<%=s_in.get("PAY_DT")%>
                				<%}else{%>
                					�̼���
                				<%}%>
                				<!--</a>-->
                				</td>           		
                       	    </tr>
            <%			
            			total_amt  = total_amt  + Long.parseLong(String.valueOf(s_in.get("S_AMT")));
            			total_amt2 = total_amt2 + Long.parseLong(String.valueOf(s_in.get("V_AMT")));
            			total_amt3 = total_amt3 + Long.parseLong(String.valueOf(s_in.get("AMT")));
            		}%>
                            <tr> 
                                <td class="title">&nbsp;</td>
                                <td class="title">&nbsp;</td>
                                <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��&nbsp;</td>
                                <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>��&nbsp;</td>
                                <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%>��&nbsp;</td>
                                <td class="title">&nbsp;</td>		  
                            </tr>            
                        </table>
	                </td>            		            		
       	        </tr>
<%	}else{%>
                <tr>
   		            <td width=55% class=line id='D1_col' style='position:relative;'>
                        <table border=0 cellspacing=1 width=100%>
            	            <tr>
            				    <td align="center" width=200></td>
            			    </tr>
            			</table>
		            </td>            		            		
                    <td class=line width=45%>
                        <table border=0 cellspacing=1 width=100%>
            			    <tr>
            				    <td> &nbsp;��ϵ� ����Ÿ�� �����ϴ�.</td>
            			    </tr>
            			</table>
		            </td>            		            		
                </tr>
<%	}%>
            </table>
        </td>
    </tr>
</table>
<form action="inc_s_frame.jsp" name="form1" method="post" target="d_content">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
</form>
</body>
</html>
