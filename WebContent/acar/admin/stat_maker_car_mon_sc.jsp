<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String maker 	= request.getParameter("maker")==null?"0001":request.getParameter("maker");
	String gubun2 	= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");	
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 4; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(height < 50) height = 150;
	
	Vector cars = ad_db.getStatMakerCarMon2(maker, gubun2, gubun3, gubun4, st_dt, end_dt);
	int cars_size = cars.size();
	
	int s01=0, s02=0, s03=0, s04=0, s05=0, s06=0, s07=0, s08=0, s09=0, s10=0, s11=0, s12=0;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//��༭ ���� ����
	function view_cont(use_yn, m_id, l_cd, b_lst){
		var fm = document.form1;
		fm.use_yn.value = use_yn;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.mode.value = '2'; /*��ȸ*/
		fm.b_lst.value = b_lst;
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15" rightmargin=0>
<form name="form1">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
	    <td>
    		<table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>
                      <% if(maker.equals("0001"))	out.print("�����ڵ���");
        						else if(maker.equals("0002"))	out.print("����ڵ���");
        						else if(maker.equals("0003"))	out.print("�����ڵ���");
        						else if(maker.equals("0004"))	out.print("�ѱ�GM");
        						else if(maker.equals("0005"))	out.print("�ֿ��ڵ���");
        						else if(maker.equals("0000"))	out.print("��Ÿ");
        						else 							out.print("��ü"); %>
                    </span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line>
        			    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                		        <td class="title" width="18%">����</td>
                		        <td class="title" width="10%">�հ�</td>
                    		    <td class="title" width="6%">1��</td>
                    		    <td class="title" width="6%">2��</td>
                    		    <td class="title" width="6%">3��</td>
                    		    <td class="title" width="6%">4��</td>
                    		    <td class="title" width="6%">5��</td>				  				  				  				  
                    		    <td class="title" width="6%">6��</td>
                    		    <td class="title" width="6%">7��</td>
                    		    <td class="title" width="6%">8��</td>
                    		    <td class="title" width="6%">9��</td>
                    		    <td class="title" width="6%">10��</td>				  				  				  				  
                    		    <td class="title" width="6%">11��</td>				  				  				  				  
                    		    <td class="title" width="6%">12��</td>				  				  				  				  				  				  
            		        </tr>
                    		<%for(int i=0; i<cars.size(); i++){
            					Hashtable ht = (Hashtable)cars.elementAt(i);
            					s01 += AddUtil.parseInt((String)ht.get("Y01"));
            					s02 += AddUtil.parseInt((String)ht.get("Y02"));
            					s03 += AddUtil.parseInt((String)ht.get("Y03"));
            					s04 += AddUtil.parseInt((String)ht.get("Y04"));
            					s05 += AddUtil.parseInt((String)ht.get("Y05"));
            					s06 += AddUtil.parseInt((String)ht.get("Y06"));
            					s07 += AddUtil.parseInt((String)ht.get("Y07"));
            					s08 += AddUtil.parseInt((String)ht.get("Y08"));
            					s09 += AddUtil.parseInt((String)ht.get("Y09"));
            					s10 += AddUtil.parseInt((String)ht.get("Y10"));
            					s11 += AddUtil.parseInt((String)ht.get("Y11"));
            					s12 += AddUtil.parseInt((String)ht.get("Y12"));
            			 	%>
                    		<tr>           
                                <td class="title"><%= ht.get("CAR_NM") %></td>
                                <td align="right"><%= ht.get("TOTAL") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y01") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y02") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y03") %>&nbsp;&nbsp;&nbsp;</td>		  
            		            <td align="right"><%= ht.get("Y04") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y05") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y06") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y07") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y08") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y09") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y10") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y11") %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= ht.get("Y12") %>&nbsp;&nbsp;&nbsp;</td>        
                            </tr>
                           <%	} %>
                            <tr>           
                                <td class="title">�հ�</td>
                                <td align="right"><%= s01+s02+s03+s04+s05+s06+s07+s08+s09+s10+s11+s12 %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= s01 %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= s02 %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= s03 %>&nbsp;&nbsp;&nbsp;</td>		  
            		            <td align="right"><%= s04 %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= s05 %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= s06 %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= s07 %>&nbsp;&nbsp;&nbsp;</td>		  
            		            <td align="right"><%= s08 %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= s09 %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= s10 %>&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><%= s11 %>&nbsp;&nbsp;&nbsp;</td>		  
            		            <td align="right"><%= s12 %>&nbsp;&nbsp;&nbsp;</td>
                            </tr>		
                        </table>
	                </td>
                </tr>          
            </table>
	    </td>
	</tr>
</table>
</form>
</body>
</html>
