<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
	
	Vector vt = sb_db.getStatRentUserDept("", "", s_yy, s_mm);
	int vt_size = vt.size();

	int count = 1;
	
	//�����׷� �Ұ�
	int cnt1[] 	= new int[25];
	//ū�׷� �Ұ�
	int cnt2[] 	= new int[25];
	//���հ�
	int cnt3[] 	= new int[25];
	
	//ū�׷�
	String gubun_cd[] 	= new String[5];
	gubun_cd[0] 	= "12";
	gubun_cd[1] 	= "11";
	gubun_cd[2] 	= "22";
	gubun_cd[3] 	= "21";
	gubun_cd[4] 	= "33";
	//ū�׷�
	String gubun_nm[] 	= new String[5];
	gubun_nm[0] 	= "������ ������";
	gubun_nm[1] 	= "������ ��������";
	gubun_nm[2] 	= "���� ������";
	gubun_nm[3] 	= "���� ��������";
	gubun_nm[4] 	= "������Ʈ";	
	
	//�����׷� : ����-�� ����
	Vector vt2 = sb_db.getStatRentDept();
	int vt_size2 = vt2.size();	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1480>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
	    <td class=line> 
	        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td class=title rowspan="2" width="110" >�μ�</td>
                    <td class=title rowspan="2" width="30">����</td>
                    <td class=title rowspan="2" width="50">����</td>
                    <td class=title rowspan="2" width="90">�Ի�����</td>               
                    <td class=title rowspan="2" width="50"> ���հ�</td>
                    <td class=title colspan="7">�հ�</td>
                    <td class=title colspan="7">�Ϲݽ�</td>
                    <td class=title colspan="7">�⺻��</td>
                    <td class=title rowspan="2" width="50">����<br>���</td>
                    <td class=title rowspan="2" width="50">����Ʈ</td>
                </tr>
                <tr align="center"> 
                    <td class=title width="50">�ű�</td>
                    <td class=title width="50">����</td>
                    <td class=title width="50">����</td>
                    <td class=title width="50">�Ұ�</td>
                    <td class=title width="50">�縮��</td>
                    <td class=title width="50">����</td>
                    <td class=title width="50">��</td>
                    <td class=title width="50">�ű�</td>
                    <td class=title width="50">����</td>
                    <td class=title width="50">����</td>
                    <td class=title width="50">�Ұ�</td>
                    <td class=title width="50">�縮��</td>
                    <td class=title width="50">����</td>
                    <td class=title width="50">��</td>
                    <td class=title width="50">�ű�</td>
                    <td class=title width="50">����</td>
                    <td class=title width="50">����</td>
                    <td class=title width="50">�Ұ�</td>
                    <td class=title width="50">�縮��</td>
                    <td class=title width="50">����</td>
                    <td class=title width="50">��</td>                                                            
                </tr>
                <%for (int g = 0 ; g < 5 ; g++){
                		for (int k = 0 ; k < 24 ; k++){ cnt2[k] = 0; }		               	
           	    %> 	            
           	    
           	    
           	    
                <%		for (int i = 0 ; i < vt_size2 ; i++){
    						Hashtable ht2 = (Hashtable)vt2.elementAt(i);	
   							if(gubun_cd[g].equals(String.valueOf(ht2.get("LOC_ST"))+""+String.valueOf(ht2.get("LOAN_ST")))){
   								for (int k = 0 ; k < 24 ; k++){ cnt1[k] = 0; }	
           	    				for (int j = 0 ; j < vt_size ; j++){
    								Hashtable ht = (Hashtable)vt.elementAt(j);    					
    								if(String.valueOf(ht.get("BR_NM")).equals(String.valueOf(ht2.get("BR_NM")))){    						
           	    %>


               <tr> 
                    <td align="center" width="110" height="20"><%= String.valueOf(ht.get("BR_NM"))%></td>
                    <td align="center" width="30" height="20"><%=count++%></td>
                    <td align="center" width="50" height="20"><%= String.valueOf(ht.get("USER_NM"))%></font></a></td>
                    <td align="center" width="90" height="20"><%=AddUtil.ChangeDate2( String.valueOf(ht.get("ENTER_DT")))%></td>
                    <%					for (int k = 0 ; k < 24 ; k++){
                    						cnt1[k] = cnt1[k] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+k)));
                    						cnt2[k] = cnt2[k] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+k)));
                    						cnt3[k] = cnt3[k] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+k)));
                    %>
	                <td align="center" <%if(k==7 || k==14 || k==21){%>class=g<%}%>><%= String.valueOf(ht.get("CNT"+k))%></td>
	                <%					}%>
                </tr>
                <%					}
	            				}	                		
                %> 
                

                <tr> 
                    <td class=is align="center" colspan='4'><%= String.valueOf(ht2.get("BR_NM"))%> �Ұ�</td>
                    <%			for (int k = 0 ; k < 24 ; k++){%>
	                <td class=is align="center"><%=cnt1[k]%></td>
	                <%			}%>
                </tr>                	
                <%			}%>

                <%		}%>           	    
           	    
           	    
           	    
           	    
           	    
           	    <%			if(!gubun_nm[g].equals("������Ʈ")){ %>		

                <tr> 
                    <td class=title colspan='4'><%=gubun_nm[g]%> �Ұ�</td>
                    <%		for (int k = 0 ; k < 24 ; k++){%>
	                <td class=title><%=cnt2[k]%></td>
	                <%		}%>
                </tr>           
                
                <%			} %>            
                
                
                
                <%	}%>
                
                <tr> 
                    <td class=title_p colspan='4'>�ѼҰ�</td>
                    <%		for (int k = 0 ; k < 24 ; k++){%>
	                <td class=title_p><%=cnt3[k]%></td>
	                <%		}%>
                </tr>                       
            </table>
	    </td>
	</tr>
</table>		
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
