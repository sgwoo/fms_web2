<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.commi_mng.*, acar.car_office.*"%>
<jsp:useBean id="acm_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/agent/cookies.jsp" %>
<%@ include file="/agent/access_log.jsp" %>

<%
	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
		
	
	String st_year = request.getParameter("st_year")==null?Integer.toString(AddUtil.getDate2(1)):request.getParameter("st_year");//�ͼӿ���
	String st_dt = st_year  + "0101";
	String end_dt = st_year + "1231";	
	
	int year = AddUtil.parseInt(st_year);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	
	String emp_id  = "";
	
	emp_id = c_db.getNameById(ck_acar_id, "USER_SA");
	String emp_acc_nm = request.getParameter("emp_acc_nm")==null?"":request.getParameter("emp_acc_nm");//�Ǽ�����

	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp_id);
	
	//�Ǽ�����
	Vector emp_acc = acm_db.getEmpAccList(emp_id );
	int  emp_acc_size = emp_acc.size();
	
	Hashtable emp_i = acm_db.getEmpAccNm(emp_id, emp_acc_nm);	
			
	Vector commis = acm_db.getCommiReceiptList("", "9", "4", "2", "", st_dt, end_dt, "13", emp_acc_nm, "9", "0" , ck_acar_id, emp_id  );
	int commi_size = commis.size();
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 11; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height);//��Ȳ ���μ���ŭ ���� ���������� ������
	
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>���� ����</title>

<STYLE>
<!--
* {line-height:130%; font-size:10.0pt; font-family:����ü;}


.style11 {border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style12 {border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style13 {border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style14 {border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style15 {border-right:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style16 {border-left:solid #000000 1px;border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style17 {border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt; height:30px;}
.style18 {font-size:8.0pt; text-align:center;  background-color:#ffffcc; height:20px;}


.f1{font-size:13pt; font-weight:bold; line-height:150%;}
.f2{font-size:10.5pt; line-height:150%;}
-->
</STYLE>
<script language="JavaScript" type="text/JavaScript">

<!--
function Search()
{
		var fm = document.form1;
	
		fm.target =  "_self";
		fm.action =  "commi_receipt.jsp";
		fm.submit();
}

function Print()
{
		
		var fm = document.form1;
	
		fm.action = "commi_receipt_print.jsp";
		fm.target = "i_no";
	//	fm.target = "_blank";	
		fm.submit();		
		
}


//-->
</script>

</head>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form  name="form1"  method="POST">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=5>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>Agent> ������� > <span class=style5>��õ¡������������</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
     <tr> 
      <td> 
        <table width="100%" border="0" cellpadding="0" cellspacing="1">
          <tr> 
          	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
			 
		            <select name="st_year" >
						<%for(int i=2012; i<=year; i++){%>
						<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>��</option>
						<%}%>
					</select> 					
		</td>
		
		   <td>&nbsp;&nbsp;&nbsp;
			 
			     <select name='emp_acc_nm'>
                <option value="">����</option>
                <%	if(emp_acc_size > 0){
						for(int i = 0 ; i < emp_acc_size ; i++){
							Hashtable emp_nm = (Hashtable)emp_acc.elementAt(i); %>
		                <option value='<%=emp_nm.get("EMP_ACC_NM")%>' <%if ( emp_acc_nm.equals(String.valueOf( emp_nm.get("EMP_ACC_NM")) )  ){%>selected<%}%>><%=emp_nm.get("EMP_ACC_NM")%></option>
		                <%		}
							}%>
		              </select></td>              
              			
		</td>
	          
             <td align=right>  
            <a href='javascript:Search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;
              <a href='javascript:Print()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;
             
           </td>
           </tr>
        </table>
      </td>
      <tr><td class=h></td></tr>


<div id="Layer1" style="position:absolute; left:600px; top:620px; width:54px; height:41px; z-index:1"></div>
<table width="700" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000">
	<tr>
		<td bgcolor="#FFFFFF">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0" height=90>
				            <tr>
				                <td valign=top>
				                	<TABLE border="0" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
					                    <TR>
					                        <TD width="43" height="33" class=style13 align=center>�ͼ�<br>����</TD>
					                        <TD width="63" class=style16 align=right><%=  st_year%>��</TD>
					                    </TR>
				                	</TABLE>
				                </td>
				                <td>
				                	<span class=f1>&nbsp;&nbsp;&nbsp;[&nbsp;] �������� ����ҵ� ��õ¡��������</span><br>
				                    <span class=f1>&nbsp;&nbsp;&nbsp;[&nbsp;] �������� ����ҵ� ���޸���</span><br>
				                    <span class=f2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( <input name="checkbox" type="checkbox" value="checkbox" checked>�ҵ��� ������&nbsp;&nbsp;<input name="checkbox" type="checkbox" value="checkbox">������ ������ )</span></td>
				                <td align=right>
				                	<TABLE border="0" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
					                    <TR>
					                        <TD colspan="2" width="95" height="25" align="center" class=style17>�����ܱ���</TD>
					                        <TD colspan="2" width="105" align="center" class=style12><img src=/agent/images/receipt_img.gif></TD>
					                    </TR>
					                    <TR>
					                        <TD width="36" height="30" align="center" class=style17>��������</TD>
					                        <TD width="44" align="center" class=style17>&nbsp;</TD>
					                        <TD width="58" align="center" class=style17>���������ڵ�</TD>
					                        <TD width="35" align="center" class=style14>&nbsp;</TD>
					                    </TR>
				                	</TABLE>
				                </td>
				            </tr>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <TR>
								<TD width="59" rowspan="2" align=center class=style11>¡&nbsp; ��<br>�ǹ���</TD>
								<TD width="90" height="34" class=style11>1.�����<br>&nbsp;&nbsp;��Ϲ�ȣ</TD>
								<TD width="115" class=style11>&nbsp;128-81-47957</TD>
								<TD width="85" class=style11>2.���θ�<br>&nbsp;&nbsp;�Ǵ� ��ȣ</TD>
								<TD colspan="2" class=style11>&nbsp;(��)�Ƹ���ī</TD>
								<TD width="50" class=style11>3.����</TD>
							    <TD width="110" class=style12>&nbsp;������</TD>
				            </TR>
							<TR>
								<TD height="28" class=style13>4.�ֹ�(����)<br>&nbsp;&nbsp;��Ϲ�ȣ</TD>
								<TD class=style13>&nbsp;115611-0019610</TD>
								<TD class=style13>5.������<br>&nbsp;&nbsp;�Ǵ� �ּ�</TD>
							    <TD colspan="4" class=style14>&nbsp;���� �������� ���ǵ��� 17-3 ����̾ؾ����� 8��</TD>
						    </TR>
							<TR>
								<TD rowspan="4" align=center class=style13>�ҵ���</TD>
								<TD style="height:28px" class=style13>6.��&nbsp;&nbsp;&nbsp;&nbsp;ȣ</TD>
								<TD colspan="2" class=style13>&nbsp;</TD>
								<TD width="105" height="33" class=style13>7.����ڵ�Ϲ�ȣ</TD>
								<TD colspan="3" class=style14>&nbsp;</TD>
						    </TR>
							<TR>
								<TD height="28" class=style13>8.�����<br>&nbsp;&nbsp;������</TD>
							    <TD colspan="6" class=style14>&nbsp;</TD>
						    </TR>
	
	<% if (  emp_acc_nm.equals("") ) {%>					    
							<TR>
								<TD style="height:28px" class=style13>9.&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
								<TD colspan="2" class=style13>&nbsp;<%=coe_bean.getEmp_nm()%></TD>
								<TD class=style13>10.�ֹε�Ϲ�ȣ</TD>
								<TD colspan="3" class=style14>&nbsp;<%= coe_bean.getEmp_ssn1() %> - <%= coe_bean.getEmp_ssn2() %></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style13>11.��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
							    <TD colspan="6" class=style14>&nbsp;<%=coe_bean.getEmp_addr()%></TD>
						    </TR>
						    
    <% } else {%>
    						<TR>
								<TD style="height:28px" class=style13>9.&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
								<TD colspan="2" class=style13>&nbsp;<%=emp_acc_nm%></TD>
								<TD class=style13>10.�ֹε�Ϲ�ȣ</TD>
								<TD colspan="3" class=style14>&nbsp;<%=emp_i.get("REC_SSN1")%> - <%=emp_i.get("REC_SSN2")%></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style13>11.��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
							    <TD colspan="6" class=style14>&nbsp;<%=emp_i.get("REC_ADDR")%></TD>
						    </TR>
    <% } %>			
    					    
					
						</table>
					</td>
				</tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD colspan="4" width="110" style="height:35px" align=center class=style14>12.��������</TD>
								<TD colspan="6" width="93" align=center style='border-left:solid #000000 2px;border-right:solid #000000 2px;border-top:solid #000000 1px;border-bottom:solid #000000 2px;padding:1.4pt 1.4pt 1.4pt 1.4pt'><b>940911</b></TD>
								<TD colspan="11" width="516" class=style14> �� �ۼ���� ����</TD>
							</TR>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD style="height:28px"  colspan="3" class=style13 align=center>13.��&nbsp;&nbsp;&nbsp;&nbsp; ��</TD>
								<TD colspan="2" class=style13>14.�ҵ�ͼ�</TD>
								<TD rowspan="2" colspan="2" class=style13>15.�� �� �� ��</TD>
								<TD width="54"rowspan="2" class=style13>16.����(%)</TD>
								<TD colspan="3" class=style14>��&nbsp; õ&nbsp; ¡&nbsp; ��&nbsp; ��&nbsp; ��</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" style="height:28px" class=style13>��</TD>
								<TD width="30" class=style13>&nbsp;��</TD>
								<TD width="30" class=style13>��</TD>
								<TD width="41" class=style13>��</TD>
								<TD width="30" class=style13>��</TD>
								<TD width="100" class=style13>17.�� �� ��</TD>
								<TD width="100" class=style13>18.����ҵ漼</TD>
								<TD width="100" class=style14>19.��</TD>
							</TR>
<%	if(commi_size <1){%>	
<%		for(int i = 0 ; i < 12 ; i++){ %>								
							<TR>
								<TD style="height:23px" class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD colspan="2" class=style13 align=right>&nbsp;</TD>
								<TD class=style13 align=right>&nbsp;</TD>
								<TD class=style13 align=right>&nbsp;</TD>
								<TD class=style13 align=right>&nbsp;</TD>
								<TD class=style14 align=right>&nbsp;</TD>
							</TR>
<%	} %>						

<% } else { %>
<%		for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);
				
				total_amt = total_amt  + Long.parseLong(String.valueOf(commi.get("COMMI")));
        				total_amt2 = total_amt2  + Long.parseLong(String.valueOf(commi.get("INC_AMT")));
        				total_amt3 = total_amt3  + Long.parseLong(String.valueOf(commi.get("RES_AMT")));
        				total_amt4 = total_amt4  + Long.parseLong(String.valueOf(commi.get("COMMI_FEE")));  %>

							<TR>
								<TD style="height:23px" class=style13>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style13>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style13>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style13>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style13>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style13 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style14  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>

	<% } %>
<% } %>					
						   	<TR>
								<TD style="height:23px" class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD colspan="2"  class=style13 align=right>&nbsp;<%=Util.parseDecimal(total_amt)%></TD>
								<TD class=style13 align=right>&nbsp;</TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseDecimal(total_amt2)%></TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseDecimal(total_amt3)%></TD>
								<TD class=style14  align=right>&nbsp;<%=Util.parseDecimal(total_amt4)%></TD>
							</TR>		
							
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD style="height:22px" colspan=2 style="border-top:1px solid #000000;">&nbsp;���� ��õ¡������(���Աݾ�)�� ���� ����(����)�մϴ�.</TD>
				    		</TR>
							<TR>
								<TD style="height:22px" colspan=2 align=right><%=AddUtil.getDate2(1)%>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate2(2)%> ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=AddUtil.getDate2(8)%>��
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD style="height:22px" align=right width=300>¡��(����)�ǹ���</td>
								<td align=right>�� �� �� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� �Ǵ� ��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD style="height:22px" colspan=2 valign=top class=style14 STYLE="font-size:13.0pt;��font-weight:bold;line-height:160%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �� �� �� &nbsp;&nbsp;����</TD>
							</TR>
						</table>
					</td>
			    </tr>
			    <tr>
			        <td style="height:5px;"></td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="690" border="0" cellspacing="0" cellpadding="0" >
			            	<TR>
								<TD colspan="21" width="678" style="height:25px;background-color:#c1c1c1;" align="center">
								�� �� �� ��
								</TD>
							</TR>
							<TR>
								<TD colspan="21" width="678" style="height:80px" style="font-size:8pt;" align=left>
								&nbsp;&nbsp;1. �� ������ �����ڰ� ����ҵ��� �߻��� ��쿡�� �ۼ��ϸ�, ������ڴ� ���� ��23ȣ����(5)�� ����Ͽ��� �մϴ�.<br>
								&nbsp;&nbsp;2. ¡���ǹ��ڶ��� ���ֹ�(����)��Ϲ�ȣ�� �ҵ��� �����뿡�� ���� �ʽ��ϴ�.<br>
								&nbsp;&nbsp;3. ������ �Ҿ׺�¡���� �ش��ϴ� ��쿡�� (17.) (18.) (19.)���� ������ ��0������ �����ϴ�.<br>
								&nbsp;&nbsp;4. (12.)�������ж����� �ҵ����� ������ �ش��ϴ� �Ʒ��� ���������ڵ带 ����� �մϴ�.</td>
							</tr>
							<tr>
								<td align=center>
									<TABLE width="690" border="0" cellspacing="1" cellpadding="0" align=center bgcolor=#3f3f3f>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>�����ڵ�</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>�����ڵ�</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>�����ڵ�</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>�����ڵ�</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>�����ڵ�</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>����</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940100</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940305</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>���ǰ�</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940904</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>�������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940910</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>�ٴܰ��Ǹ�</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940916</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>��絵���</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940200</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>ȭ������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940500</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>��������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940905</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>����������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940911</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>��Ÿ��������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940917</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>�ɺθ��뿪</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940301</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>�۰</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940600</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>�ڹ�����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940906</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>���輳��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940912</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940918</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>������</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940302</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>���</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940901</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>�ٵϱ��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940907</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940913</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>�븮����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940919</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>��ǰ���</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940303</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940902</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>�ɲ��̱���</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940908</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>����.����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940914</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>ĳ��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>851101</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>���ǿ�</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940304</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940903</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>�п�����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940909</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>��Ÿ�ڿ�</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940915</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>��������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>&nbsp;</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>&nbsp;</TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
							<tr>
								<td height=5></td>
							</tr>
			        	</table>
			        </td>
			    </tr>
			</table>
		</td>
	</tr>	
  </form>
</table>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</body>
</html>
