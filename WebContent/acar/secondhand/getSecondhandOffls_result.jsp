<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String est_id 	= request.getParameter("est_id")	==null?"":request.getParameter("est_id");
	
	String car_mng_id 	= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");
	String today_dist	= request.getParameter("today_dist")	==null?"":request.getParameter("today_dist");
		
	out.println(car_mng_id);
	
	//Vector vt = vt = e_db.getEstiMateResultOfflsCaramtList("estimate", car_mng_id, rent_dt, today_dist);	
	Vector vt = vt = e_db.getEstiMateResultOfflsCaramtList(car_mng_id);
	int vt_size = vt.size();
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--


//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
</form>	
<script>
<!--
//-->
</script>	
<table border=0 cellspacing=0 cellpadding=0 width=<%=500+(100*vt_size)%>>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > <span class=style5>�������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
	<tr> 
      <td>
        <table width=100% border="0" cellspacing="0" cellpadding="0">
          <tr> 
		    <td class="line">
			  <table width=400 border="0" cellspacing="1" cellpadding="0">
                <tr> 
				  <td class=title>������ȣ</td>
				</tr>
                <tr> 
				  <td class=title>����</td>
				</tr>
                <tr> 
				  <td class=title>�����ڵ庰����������</td>
				</tr>
                <tr> 
				  <td class=title>����Ͻ�</td>
				</tr>
                <tr> 
				  <td class=title>�������</td>
				</tr>
                <tr> 
				  <td class=title>�̿�Ⱓ</td>
				</tr>
                <tr> 
				  <td class=title>�⺻����</td>
				</tr>
                <tr> 
				  <td class=title>�ɼǱݾ�</td>
				</tr>
                <tr> 
				  <td class=title>����ݾ�</td>
				</tr>
                <tr> 
				  <td class=title>���Ҽ������</td>
				</tr>
                <tr> 
				  <td class=title>�����ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>������ ����24���� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>2���� ����24���� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>�����ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>���� ���� ����ܰ���(�뿩���� ���� ����)</td>
				</tr>
                <tr> 
				  <td class=title>�뿩������� �⺻���� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>�뿩���� ���� �߰�����1</td>
				</tr>
                <tr> 
				  <td class=title>�뿩���� ���� �߰�����2</td>
				</tr>
                <tr> 
				  <td class=title>�뿩���� ���� �߰�����</td>
				</tr>
                <tr> 
				  <td class=title>�������� ���� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>���������-���⵵����</td>
				</tr>
                <tr> 
				  <td class=title>������Ͽ� �ݿ� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>36���� �ʰ������� �ܰ� ������</td>
				</tr>
                <tr> 
				  <td class=title>���������� �ִ��ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>���� ������Ÿ�</td>
				</tr>
                <tr> 
				  <td class=title>�߰����ܰ� ������ ���Ⱓ ��ǥ������Ÿ�</td>
				</tr>				
                <tr> 
				  <td class=title>ǥ������Ÿ� ��� ��������Ÿ� ����</td>
				</tr>
                <tr> 
				  <td class=title>�߰����� ������</td>
				</tr>				
                <tr> 
				  <td class=title>��������Ÿ� �ݿ� �ִ��ܰ���</td>
				</tr>	
                <tr> 
				  <td class=title>(��)������ �⺻���� �ܰ���</td>
				</tr>					
                <tr> 
				  <td class=title>(��)����Ÿ��� ���� �߰����� ������</td>
				</tr>					
                <tr> 
				  <td class=title>(��)����Ÿ��� ���� �߰����� ������</td>
				</tr>	
                <tr> 
				  <td class=title>(��)������ �߰�����(����Ÿ��ݿ�,������)</td>
				</tr>									
                <tr> 
				  <td class=title>(��)������ ����� ��������(����Ÿ��ݿ�)</td>
				</tr>	
                <tr> 
				  <td class=title>(��)�縮��������� �����ܰ���(����������忹��)</td>
				</tr>	
                <tr> 
				  <td class=title>(��)�縮��������� �����ܰ���(�����������)</td>
				</tr>									
                <tr> 
				  <td class=title>(��)�縮�� �� ������ ���� �����ܰ���</td>
				</tr>	
                <tr> 
				  <td class=title>(��)�߰��� ���庯ȯ�� ���� ����ũ�� ������ �����ܰ���</td>
				</tr>					
                <tr> 
				  <td class=title>(��)�߰��� �������� �����ܰ���(����)</td>
				</tr>	
                <tr> 
				  <td class=title>1�� ��������</td>
				</tr>															
                <tr> 
				  <td class=title>2�� ��������</td>
				</tr>															
                <tr> 
				  <td class=title>���� �� ��� �ܰ��ݿ�</td>
				</tr>		
                <tr> 
				  <td class=title>�� ��������</td>
				</tr>
					
                <tr> 
				  <td class=title>��������</td>
				</tr>	

                <tr> 
				  <td class=title>��������Ÿ�</td>
				</tr>				
											
			  </table>	
			</td>		  
		    <td class="line">
			  <table width=100 border="0" cellspacing="1" cellpadding="0">
                <tr> 
				  <td class=title>EST_ID</td>
				</tr>
                <tr> 
				  <td class=title>GUBUN</td>
				</tr>
				<tr> 
				  <td class=title>JG_B_DT</td>
				</tr>
                <tr> 
				  <td class=title>REG_DT</td>
				</tr>
				<tr> 
				  <td class=title>RENT_DT</td>
				</tr>
                <tr> 
				  <td class=title>A_B</td>
				</tr>
                <tr> 
				  <td class=title>CAR_AMT</td>
				</tr>
                <tr> 
				  <td class=title>OPT_AMT</td>
				</tr>
                <tr> 
				  <td class=title>COL_AMT</td>
				</tr>
				<tr> 
				  <td class=title>TAX_DC_AMT</td>
				</tr>
                <tr> 
				  <td class=title>RO_13</td>
				</tr>
                <tr> 
				  <td class=title>O_B</td>
				</tr>
                <tr> 
				  <td class=title>O_C</td>
				</tr>
                <tr> 
				  <td class=title>O_D</td>
				</tr>
                <tr> 
				  <td class=title>O_E</td>
				</tr>
                <tr> 
				  <td class=title>O_F</td>
				</tr>
                <tr> 
				  <td class=title>O_G1</td>
				</tr>
                <tr> 
				  <td class=title>O_G2</td>
				</tr>
                <tr> 
				  <td class=title>O_G</td>
				</tr>
                <tr> 
				  <td class=title>O_H</td>
				</tr>
                <tr> 
				  <td class=title>DAY</td>
				</tr>
                <tr> 
				  <td class=title>O_I</td>
				</tr>
                <tr> 
				  <td class=title>O_K</td>
				</tr>
                <tr> 
				  <td class=title>O_M</td>
				</tr>
                <tr> 
				  <td class=title>BM7</td>
				</tr>
                <tr> 
				  <td class=title>BM9</td>
				</tr>				
                <tr> 
				  <td class=title>BM10</td>
				</tr>
                <tr> 
				  <td class=title>BM12</td>
				</tr>				
                <tr> 
				  <td class=title>BM14</td>
				</tr>				
                <tr> 
				  <td class=title>O_F_R</td>
				</tr>					
                <tr> 
				  <td class=title>O_R</td>
				</tr>					
                <tr> 
				  <td class=title>O_R_R</td>
				</tr>	
                <tr> 
				  <td class=title>O_S_R</td>
				</tr>									
                <tr> 
				  <td class=title>O_S</td>
				</tr>	
                <tr> 
				  <td class=title>O_U</td>
				</tr>	
                <tr> 
				  <td class=title>O_V</td>
				</tr>									
                <tr> 
				  <td class=title>O_W</td>
				</tr>	
                <tr> 
				  <td class=title>O_X</td>
				</tr>					
                <tr> 
				  <td class=title>O_Y</td>
				</tr>	
                <tr> 
				  <td class=title>accid_serv_amt1</td>
				</tr>																	
                <tr> 
				  <td class=title>accid_serv_amt2</td>
				</tr>																	
                <tr> 
				  <td class=title>jg_opt_st</td>
				</tr>																	
				
                <tr> 
				  <td class=title>ACCID_SIK_J</td>
				</tr>	
                <tr> 
				  <td class=title>O_1</td>
				</tr>	

                <tr> 
				  <td class=title>TODAY_DIST</td>
				</tr>				
			  </table>	
			</td>				
			<% 	if(vt.size()>0){
					for(int i=0; i<vt.size(); i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>		  						
		    <td class="line">
			  <table width=100 border="0" cellspacing="1" cellpadding="0">
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("EST_ID")%></td>				  
				</tr>
                <tr> 
				  <td  class=title style="font-size : 8pt;"><%=ht.get("GUBUN")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_B_DT")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("REG_DT")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("RENT_DT")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("A_B")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("CAR_AMT")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("OPT_AMT")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("COL_AMT")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("TAX_DC_AMT")%></td>				  
				</tr>
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("RO_13")%>%</td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_B")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_C")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_D")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_E")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_F")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_G1")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_G2")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_G")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_H")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("DAY")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_I")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_K")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_M")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM7")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM9")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM10")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM12")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM14")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_F_R")%></td>				  
				</tr>					
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_R")%></td>
				</tr>					
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_R_R")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_S_R")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_S")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_U")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_V")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_W")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_X")%></td>
				</tr>					
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Y")%></td>
				</tr>
                                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ACCID_SERV_AMT1")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ACCID_SERV_AMT2")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_OPT_ST")%> <%=ht.get("JG_COL_ST")%></td>
				</tr>									
								
								
				
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("ACCID_SIK_J")%></td>				  
				</tr>
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_1")))%>��</td>				  
				</tr>

                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("TODAY_DIST")%></td>
				</tr>				
			  </table>	
			</td>
			<%		}
				}%>			
		  </tr>
		</table>
	  </td>
	</tr>  
		  	</table>
</body>
</html>
