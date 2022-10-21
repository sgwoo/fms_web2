<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.commi_mng.*, acar.car_office.*"%>
<jsp:useBean id="acm_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String st_year = request.getParameter("st_year")==null?Integer.toString(AddUtil.getDate2(1)):request.getParameter("st_year");//�ͼӿ���
	
	String st_dt = st_year  + "0101";
	String end_dt = st_year + "1231";	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");//�������  id
	String emp_acc_nm = request.getParameter("emp_acc_nm")==null?"":request.getParameter("emp_acc_nm");//�Ǽ�����
	
	//default:�������	
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp_id);
	
	Hashtable emp_i = acm_db.getEmpAccNm(emp_id, emp_acc_nm);	
	
			
	Vector commis = acm_db.getCommiList("", "9", "4", "2", "", st_dt, end_dt, "13", emp_acc_nm, "9", "0" , "", emp_id  );
	int commi_size = commis.size();

	int page_size = commi_size / 12 ;
	int list_size = commi_size % 12 ;
	
	int page_size1 = (commi_size  - 12)/ 40 ;
	int list_size1 =  (commi_size  - 12)  % 40 ;
	
//	System.out.println( "commi_size=" + commi_size )  ;
	
//	System.out.println( "page_size=" + commi_size / 12 )  ;
 //     System.out.println( "list_size=" + commi_size % 12 )  ;
         
  //       System.out.println( "page_size1=" +(commi_size  - 12)/ 40 )  ;
 //        System.out.println( "list_size1=" + ( commi_size  - 12)  % 40 )  ;
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 11; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height);//��Ȳ ���μ���ŭ ���� ���������� ������
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>���� ����</title>

<STYLE>
<!--
* {line-height:130%; font-size:10.0pt; font-family:����ü;}


.style1 {border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style2 {border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style3 {border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style4 {border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style5 {border-right:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style6 {border-left:solid #000000 1px;border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style7 {border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style8 {font-size:8.0pt; text-align:center;}


.f1{font-size:13pt; font-weight:bold; line-height:150%;}
.f2{font-size:10.5pt; line-height:150%;}
-->
</STYLE>

<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		
		var userAgent = navigator.userAgent.toLowerCase();
		
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			IE_Print();
		}
		
	}
	
	function IE_Print() {
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 10.0; //��������
		factory.printing.topMargin 	= 15.0; //��ܿ���    
		factory.printing.bottomMargin 	= 12.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}

</script>

</head>

<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<%	if(page_size <1){%>	
<div id="Layer1" style="position:absolute; left:600px; top:690px; width:54px; height:41px; z-index:1"><img src="/acar/main_car_hp/images/stamp.png" width="75" height="75"></div>
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
					                        <TD width="43" height="33" class=style3 align=center>�ͼ�<br>����</TD>
					                        <TD width="63" class=style6 align=right><%= st_year%>��</TD>
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
					                        <TD colspan="2" width="95" height="25" align="center" class=style7>�����ܱ���</TD>
					                        <TD colspan="2" width="105" align="center" class=style2><img src=/acar/images/receipt_img.gif></TD>
					                    </TR>
					                    <TR>
					                        <TD width="36" height="30" align="center" class=style7>��������</TD>
					                        <TD width="44" align="center" class=style7>&nbsp;</TD>
					                        <TD width="58" align="center" class=style7>���������ڵ�</TD>
					                        <TD width="35" align="center" class=style4>&nbsp;</TD>
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
								<TD width="59" rowspan="2" align=center class=style1>¡&nbsp; ��<br>�ǹ���</TD>
								<TD width="90" height="34" class=style1>&nbsp;1.�����<br>&nbsp;&nbsp; ��Ϲ�ȣ</TD>
								<TD width="115" class=style1>&nbsp;128-81-47957</TD>
								<TD width="85" class=style1>&nbsp;2.���θ�<br>&nbsp;&nbsp; �Ǵ� ��ȣ</TD>
								<TD colspan="2" class=style1>&nbsp;(��)�Ƹ���ī</TD>
								<TD width="50" class=style1>&nbsp;3.����</TD>
							    <TD width="100" class=style2>&nbsp;������</TD>
				            </TR>
							<TR>
								<TD height="28" class=style3>&nbsp;4.�ֹ�(����)<br>&nbsp;&nbsp; ��Ϲ�ȣ</TD>
								<TD class=style3>&nbsp;115611-0019610</TD>
								<TD class=style3>&nbsp;5.������<br>&nbsp;&nbsp; �Ǵ� �ּ�</TD>
							    <TD colspan="4" class=style4>&nbsp;���� �������� ���ǵ��� 17-3 ����̾ؾ����� 8��</TD>
						    </TR>
							<TR>
								<TD rowspan="4" align=center class=style3>�ҵ���</TD>
								<TD height="28" class=style3>&nbsp;6.��&nbsp;&nbsp;&nbsp;&nbsp;ȣ</TD>
								<TD colspan="2" class=style3>&nbsp;</TD>
								<TD width="115" height="33" class=style3>&nbsp;7.����ڵ�Ϲ�ȣ</TD>
								<TD colspan="3" class=style4>&nbsp;</TD>
						    </TR>
							<TR>
								<TD height="28" class=style3>&nbsp;8.�����<br>&nbsp;&nbsp; ������</TD>
							    <TD colspan="6" class=style4>&nbsp;</TD>
						    </TR>
    <% if (  emp_acc_nm.equals("") ) {%>					    
							<TR>
								<TD style="height:28px" class=style3>9.&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
								<TD colspan="2" class=style3>&nbsp;<%=coe_bean.getEmp_nm()%></TD>
								<TD class=style3>10.�ֹε�Ϲ�ȣ</TD>
								<TD colspan="3" class=style4>&nbsp;<%= coe_bean.getEmp_ssn1() %> - <%= coe_bean.getEmp_ssn2() %></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style3>11.��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
							    <TD colspan="6" class=style4>&nbsp;<%=coe_bean.getEmp_addr()%></TD>
						    </TR>
						    
    <% } else {%>
    						<TR>
								<TD style="height:28px" class=style3>9.&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
								<TD colspan="2" class=style3>&nbsp;<%=emp_acc_nm%></TD>
								<TD class=style3>10.�ֹε�Ϲ�ȣ</TD>
								<TD colspan="3" class=style4>&nbsp;<%=emp_i.get("REC_SSN1")%> - <%=emp_i.get("REC_SSN2")%></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style3>11.��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
							    <TD colspan="6" class=style4>&nbsp;<%=emp_i.get("REC_ADDR")%></TD>
						    </TR>
    <% } %>		    
		
						</table>
					</td>
				</tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD colspan="4" width="110" height="35" align=center class=style4>12.��������</TD>
								<TD colspan="6" width="93" align=center style='border-left:solid #000000 2px;border-right:solid #000000 2px;border-top:solid #000000 1px;border-bottom:solid #000000 2px;padding:1.4pt 1.4pt 1.4pt 1.4pt'><b>940911</b></TD>
								<TD colspan="11" width="516" class=style4> �� �ۼ���� ����</TD>
							</TR>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="28" colspan="3" class=style3 align=center>13.��&nbsp;&nbsp;&nbsp;&nbsp; ��</TD>
								<TD colspan="2" class=style3 align=center>14.�ҵ�ͼ�</TD>
								<TD rowspan="2" colspan="2" class=style3 align=center>15.�� �� �� ��</TD>
								<TD width="54"rowspan="2" class=style3 align=center>16.����(%)</TD>
								<TD colspan="3" class=style4 align=center>��&nbsp; õ&nbsp; ¡&nbsp; ��&nbsp; ��&nbsp; ��</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" height="28" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="41" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="100" class=style3 align=center>17.�� �� ��</TD>
								<TD width="100" class=style3 align=center>18.����ҵ漼</TD>
								<TD width="100" class=style4 align=center>19.��</TD>
							</TR>
<%	            
	for(int i = 0 ; i <commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i); %>
			
						<TR>
								<TD height="23" class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style4  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>											

	<% } 
	for(int i = 0 ; i <12 - commi_size ; i++){			%>
				
				<TR>
								<TD height="23" class=style3>&nbsp;</TD>
								<TD class=style3>&nbsp;</TD>
								<TD class=style3>&nbsp;</TD>
								<TD class=style3>&nbsp;</TD>
								<TD class=style3>&nbsp;</TD>
								<TD colspan="2" class=style3 align=right>&nbsp;</TD>
								<TD class=style3 align=right>&nbsp;</TD>
								<TD class=style3 align=right>&nbsp;</TD>
								<TD class=style3 align=right>&nbsp;</TD>
								<TD class=style4 align=right>&nbsp;</TD>
							</TR>									

	<% } %>
					
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="22" colspan=2>&nbsp;���� ��õ¡������(���Աݾ�)�� ���� ����(����)�մϴ�.</TD>
				    		</TR>
							<TR>
								<TD height="22" colspan=2 align=right><%=AddUtil.getDate2(1)%>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate2(2)%> ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=AddUtil.getDate2(8)%>��
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD height="22" align=right width=300>¡��(����)�ǹ���</td>
								<td align=right>�� �� �� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� �Ǵ� ��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD height="22" colspan=2 valign=top class=style4 STYLE="font-size:13.0pt;��font-weight:bold;line-height:160%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �� �� �� &nbsp;&nbsp;����</TD>
							</TR>
						</table>
					</td>
			    </tr>
			    <tr>
			        <td height=5></td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="690" border="0" cellspacing="0" cellpadding="0" >
			            	<TR>
								<TD width="678" height="20" align="center" bgcolor="#c1c1c1" >
								�� �� �� ��
								</TD>
							</TR>
							<TR>
								<TD width="678" height="70" style="font-size:8pt;" align=left>
								&nbsp;&nbsp;1. �� ������ �����ڰ� ����ҵ��� �߻��� ��쿡�� �ۼ��ϸ�, ������ڴ� ���� ��23ȣ����(5)�� ����Ͽ��� �մϴ�.<br>
								&nbsp;&nbsp;2. ¡���ǹ��ڶ��� (4.)�ֹ�(����)��Ϲ�ȣ�� �ҵ��� �����뿡�� ���� �ʽ��ϴ�.<br>
								&nbsp;&nbsp;3. ������ �Ҿ׺�¡���� �ش��ϴ� ��쿡�� (17.) (18.) (19.)���� ������ ��0������ �����ϴ�.<br>
								&nbsp;&nbsp;4. (12.)�������ж����� �ҵ����� ������ �ش��ϴ� �Ʒ��� ���������ڵ带 ����� �մϴ�.</td>
							</tr>
							<tr>
								<td align=center>
									<TABLE width="690" border="0" cellspacing="1" cellpadding="0" align=center bgcolor=#3f3f3f>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>����</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940100</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940305</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>���ǰ�</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940904</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>�������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940910</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>�ٴܰ��Ǹ�</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940916</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>��絵���</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940200</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>ȭ������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940500</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>��������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940905</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>����������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940911</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>��Ÿ��������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940917</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�ɺθ��뿪</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940301</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>�۰</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940600</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�ڹ�����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940906</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>���輳��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940912</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940918</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>������</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940302</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>���</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940901</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�ٵϱ��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940907</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940913</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>�븮����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940919</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>��ǰ���</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940303</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940902</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�ɲ��̱���</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940908</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>����.����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940914</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>ĳ��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>851101</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>���ǿ�</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940304</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940903</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�п�����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940909</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>��Ÿ�ڿ�</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940915</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>��������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>&nbsp;</TD>
											<TD width="70" bgcolor="#ffffcc" class=style23>&nbsp;</TD>
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
</table>
<% } else {%>

<div id="Layer1" style="position:absolute; left:600px; top:690px; width:54px; height:41px; z-index:1"><img src="http://www.amazoncar.co.kr:8088/acar/main_car_hp/images/stamp.png" width="75" height="75"></div>
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
					                        <TD width="43" height="33" class=style3 align=center>�ͼ�<br>����</TD>
					                        <TD width="63" class=style6 align=right><%= st_year%>��</TD>
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
					                        <TD colspan="2" width="95" height="25" align="center" class=style7>�����ܱ���</TD>
					                        <TD colspan="2" width="105" align="center" class=style2><img src=/acar/images/receipt_img.gif></TD>
					                    </TR>
					                    <TR>
					                        <TD width="36" height="30" align="center" class=style7>��������</TD>
					                        <TD width="44" align="center" class=style7>&nbsp;</TD>
					                        <TD width="58" align="center" class=style7>���������ڵ�</TD>
					                        <TD width="35" align="center" class=style4>&nbsp;</TD>
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
								<TD width="59" rowspan="2" align=center class=style1>¡&nbsp; ��<br>�ǹ���</TD>
								<TD width="90" height="34" class=style1>&nbsp;1.�����<br>&nbsp;&nbsp; ��Ϲ�ȣ</TD>
								<TD width="115" class=style1>&nbsp;128-81-47957</TD>
								<TD width="85" class=style1>&nbsp;2.���θ�<br>&nbsp;&nbsp; �Ǵ� ��ȣ</TD>
								<TD colspan="2" class=style1>&nbsp;(��)�Ƹ���ī</TD>
								<TD width="50" class=style1>&nbsp;3.����</TD>
							    <TD width="100" class=style2>&nbsp;������</TD>
				            </TR>
							<TR>
								<TD height="28" class=style3>&nbsp;4.�ֹ�(����)<br>&nbsp;&nbsp; ��Ϲ�ȣ</TD>
								<TD class=style3>&nbsp;115611-0019610</TD>
								<TD class=style3>&nbsp;5.������<br>&nbsp;&nbsp; �Ǵ� �ּ�</TD>
							    <TD colspan="4" class=style4>&nbsp;���� �������� ���ǵ��� 17-3 ����̾ؾ����� 8��</TD>
						    </TR>
							<TR>
								<TD rowspan="4" align=center class=style3>�ҵ���</TD>
								<TD height="28" class=style3>&nbsp;6.��&nbsp;&nbsp;&nbsp;&nbsp;ȣ</TD>
								<TD colspan="2" class=style3>&nbsp;</TD>
								<TD width="115" height="33" class=style3>&nbsp;7.����ڵ�Ϲ�ȣ</TD>
								<TD colspan="3" class=style4>&nbsp;</TD>
						    </TR>
							<TR>
								<TD height="28" class=style3>&nbsp;8.�����<br>&nbsp;&nbsp; ������</TD>
							    <TD colspan="6" class=style4>&nbsp;</TD>
						    </TR>
     <% if (  emp_acc_nm.equals("") ) {%>					    
							<TR>
								<TD style="height:28px" class=style3>9.&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
								<TD colspan="2" class=style3>&nbsp;<%=coe_bean.getEmp_nm()%></TD>
								<TD class=style3>10.�ֹε�Ϲ�ȣ</TD>
								<TD colspan="3" class=style4>&nbsp;<%= coe_bean.getEmp_ssn1() %> - <%= coe_bean.getEmp_ssn2() %></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style3>11.��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
							    <TD colspan="6" class=style4>&nbsp;<%=coe_bean.getEmp_addr()%></TD>
						    </TR>
						    
    <% } else {%>
    						<TR>
								<TD style="height:28px" class=style3>9.&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
								<TD colspan="2" class=style3>&nbsp;<%=emp_acc_nm%></TD>
								<TD class=style3>10.�ֹε�Ϲ�ȣ</TD>
								<TD colspan="3" class=style4>&nbsp;<%=emp_i.get("REC_SSN1")%> - <%=emp_i.get("REC_SSN2")%></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style3>11.��&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
							    <TD colspan="6" class=style4>&nbsp;<%=emp_i.get("REC_ADDR")%></TD>
						    </TR>
    <% } %>		    
						</table>
					</td>
				</tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD colspan="4" width="110" height="35" align=center class=style4>12.��������</TD>
								<TD colspan="6" width="93" align=center style='border-left:solid #000000 2px;border-right:solid #000000 2px;border-top:solid #000000 1px;border-bottom:solid #000000 2px;padding:1.4pt 1.4pt 1.4pt 1.4pt'><b>940911</b></TD>
								<TD colspan="11" width="516" class=style4> �� �ۼ���� ����</TD>
							</TR>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="28" colspan="3" class=style3 align=center>13.��&nbsp;&nbsp;&nbsp;&nbsp; ��</TD>
								<TD colspan="2" class=style3 align=center>14.�ҵ�ͼ�</TD>
								<TD rowspan="2" colspan="2" class=style3 align=center>15.�� �� �� ��</TD>
								<TD width="54"rowspan="2" class=style3 align=center>16.����(%)</TD>
								<TD colspan="3" class=style4 align=center>��&nbsp; õ&nbsp; ¡&nbsp; ��&nbsp; ��&nbsp; ��</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" height="28" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="41" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="100" class=style3 align=center>17.�� �� ��</TD>
								<TD width="100" class=style3 align=center>18.����ҵ漼</TD>
								<TD width="100" class=style4 align=center>19.��</TD>
							</TR>
				
	<% 	for(int i = 0 ; i < 12  ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);  %>													
						
				<TR>
								<TD height="23" class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style4  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>	
										

	<% } %>
						
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="22" colspan=2>&nbsp;���� ��õ¡������(���Աݾ�)�� ���� ����(����)�մϴ�.</TD>
				    		</TR>
							<TR>
								<TD height="22" colspan=2 align=right><%=AddUtil.getDate2(1)%>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate2(2)%> ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=AddUtil.getDate2(8)%>��
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD height="22" align=right width=300>¡��(����)�ǹ���</td>
								<td align=right>�� �� �� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� �Ǵ� ��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD height="22" colspan=2 valign=top class=style4 STYLE="font-size:13.0pt;��font-weight:bold;line-height:160%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �� �� �� &nbsp;&nbsp;����</TD>
							</TR>
						</table>
					</td>
			    </tr>
			    <tr>
			        <td height=5></td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="690" border="0" cellspacing="0" cellpadding="0" >
			            	<TR>
								<TD width="678" height="20" align="center" bgcolor="#c1c1c1" >
								�� �� �� ��
								</TD>
							</TR>
							<TR>
								<TD width="678" height="70" style="font-size:8pt;" align=left>
								&nbsp;&nbsp;1. �� ������ �����ڰ� ����ҵ��� �߻��� ��쿡�� �ۼ��ϸ�, ������ڴ� ���� ��23ȣ����(5)�� ����Ͽ��� �մϴ�.<br>
								&nbsp;&nbsp;2. ¡���ǹ��ڶ��� (4.)�ֹ�(����)��Ϲ�ȣ�� �ҵ��� �����뿡�� ���� �ʽ��ϴ�.<br>
								&nbsp;&nbsp;3. ������ �Ҿ׺�¡���� �ش��ϴ� ��쿡�� (17.) (18.) (19.)���� ������ ��0������ �����ϴ�.<br>
								&nbsp;&nbsp;4. (12.)�������ж����� �ҵ����� ������ �ش��ϴ� �Ʒ��� ���������ڵ带 ����� �մϴ�.</td>
							</tr>
							<tr>
								<td align=center>
									<TABLE width="690" border="0" cellspacing="1" cellpadding="0" align=center bgcolor=#3f3f3f>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>�����ڵ�</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>����</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940100</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940305</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>���ǰ�</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940904</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>�������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940910</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>�ٴܰ��Ǹ�</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940916</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>��絵���</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940200</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>ȭ������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940500</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>��������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940905</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>����������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940911</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>��Ÿ��������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940917</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�ɺθ��뿪</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940301</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>�۰</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940600</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�ڹ�����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940906</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>���輳��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940912</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940918</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>������</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940302</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>���</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940901</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�ٵϱ��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940907</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940913</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>�븮����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940919</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>��ǰ���</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940303</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940902</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�ɲ��̱���</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940908</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>����.����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940914</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>ĳ��</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>851101</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>���ǿ�</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940304</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940903</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>�п�����</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940909</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>��Ÿ�ڿ�</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940915</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>��������</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>&nbsp;</TD>
											<TD width="70" bgcolor="#ffffcc" class=style23>&nbsp;</TD>
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
</table>
  <%    for(int p = 0 ; p <page_size1 ; p++) {  
             int      k=p+1;     
               %>		
             			
<p style='page-break-before:always'><br style="height:0; line-height:0"></P>

<table width="700" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000">
	<tr>
		<td bgcolor="#FFFFFF">

			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="28" colspan="3" class=style3 align=center>13.��&nbsp;&nbsp;&nbsp;&nbsp; ��</TD>
								<TD colspan="2" class=style3 align=center>14.�ҵ�ͼ�</TD>
								<TD rowspan="2" colspan="2" class=style3 align=center>15.�� �� �� ��</TD>
								<TD width="54"rowspan="2" class=style3 align=center>16.����(%)</TD>
								<TD colspan="3" class=style4 align=center>��&nbsp; õ&nbsp; ¡&nbsp; ��&nbsp; ��&nbsp; ��</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" height="28" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="41" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="100" class=style3 align=center>17.�� �� ��</TD>
								<TD width="100" class=style3 align=center>18.����ҵ漼</TD>
								<TD width="100" class=style4 align=center>19.��</TD>
							</TR>				
		 <% 	for(int i = 12+(p*40) ; i <12+(k*40)  ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);  						
				%>													
						
						        <TR>
								<TD height="23" class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style4  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>											

			<% }  %>
		
		    </table>
	</td>
	</tr>
</table>			    
    <% }   %>
<!-- ������ ������ ��� -->  
  <p style='page-break-before:always'><br style="height:0; line-height:0"></P>

<table width="700" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000">
	<tr>
		<td bgcolor="#FFFFFF">

			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="28" colspan="3" class=style3 align=center>13.��&nbsp;&nbsp;&nbsp;&nbsp; ��</TD>
								<TD colspan="2" class=style3 align=center>14.�ҵ�ͼ�</TD>
								<TD rowspan="2" colspan="2" class=style3 align=center>15.�� �� �� ��</TD>
								<TD width="54"rowspan="2" class=style3 align=center>16.����(%)</TD>
								<TD colspan="3" class=style4 align=center>��&nbsp; õ&nbsp; ¡&nbsp; ��&nbsp; ��&nbsp; ��</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" height="28" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="41" class=style3 align=center>��</TD>
								<TD width="30" class=style3 align=center>��</TD>
								<TD width="100" class=style3 align=center>17.�� �� ��</TD>
								<TD width="100" class=style3 align=center>18.����ҵ漼</TD>
								<TD width="100" class=style4 align=center>19.��</TD>
							</TR>				
		  <% for(int i = 12+(page_size1*40) ; i <12+(page_size1*40) +list_size1  ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);  						
				%>													
						
						        <TR>
								<TD height="23" class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style4  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>	
										

			<% } 
			for(int i = 0 ; i <40 - list_size1 ; i++){			%>			
						<TR>
										<TD height="23" class=style3>&nbsp;</TD>
										<TD class=style3>&nbsp;</TD>
										<TD class=style3>&nbsp;</TD>
										<TD class=style3>&nbsp;</TD>
										<TD class=style3>&nbsp;</TD>
										<TD colspan="2" class=style3 align=right>&nbsp;</TD>
										<TD class=style3 align=right>&nbsp;</TD>
										<TD class=style3 align=right>&nbsp;</TD>
										<TD class=style3 align=right>&nbsp;</TD>
										<TD class=style4 align=right>&nbsp;</TD>
						</TR>						

		    <% }     %>
		    </table>
	</td>
	</tr>
</table>			     

<% }   %>
	
</body>
</html>
