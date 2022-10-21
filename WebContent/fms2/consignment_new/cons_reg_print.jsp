<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.car_register.*, acar.client.*, acar.cont.*, acar.car_office.*, acar.car_mst.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	int    seq	 	= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	//Ź���Ƿ� 1��
	ConsignmentBean cons = cs_db.getConsignment(cons_no, seq);
	
	CarRegBean 		car 			= crd.getCarRegBean(cons.getCar_mng_id());
	ContCarBean 	car_etc 	= a_db.getContCarNew(cons.getRent_mng_id(), cons.getRent_l_cd());
	ClientBean 		client 		= al_db.getNewClient(cons.getClient_id());
	ContBaseBean 	base 		= a_db.getCont(cons.getRent_mng_id(), cons.getRent_l_cd());
	
	//Ź����ȸ���� ���������� �������ð��(20190408)
	CarMstBean		cm_bean 	= cmb.getCarNmCase(car_etc.getCar_id(), car_etc.getCar_seq());
	String car_nm = cm_bean.getCar_nm() + " " + cm_bean.getCar_name(); 
	if(car_nm.equals("")){		car_nm = car.getCar_nm();			}
	if(car_nm.equals("")){
		car 		= 		crd.getCarRegBean(base.getCar_mng_id());
		car_nm = car.getCar_nm();
	}
	if(car_nm.equals("")){
		car_nm = cmb.getCar_b_inc_name(car_etc.getCar_id(), car_etc.getCar_seq());
	}
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
	
	//�Ƿ���
	UsersBean sender_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	Vector  codes2 = new Vector();
	int c_size2 = 0;	
 	
	codes2 = c_db.getCodeAllV_0022_all("0022");	
	c_size2= codes2.size();
	 
		
		
	String white = "";
	String disabled = "";
	white = "white";
	disabled = "disabled";
	int j = seq;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script> 
<style>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	font-family: dotum,'����',gulim,'����',Helvetica,Apple-Gothic,sans-serif;
	font-size:0.8em;
	text-align:center;
	line-height:15px;
	}
.style1 {
	font-size:2.0em;
	font-weight:bold;
	line-height:28px;
}
.style2 {
	font-size:1.1em;
	font-weight:bold;}
.style3{
	font-size:0.8em;}
.style4{
	font-size:0.9em;}
.style5{
	text-decoration:underline;
	text-align:right;
	padding-right:20px;
	}
.style6{
	font-size:1.1em;}

.style7{
	text-decoration:underline;
	}
		
checkbox{padding:0px;}

table {text-align:left; border-collapse:collapse; vertical-align:middle;}
.doc table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc table td {border:1px solid #000000; height:20px; font-size:1.1em;}
.doc table td.title {font-weight:bold; background-color:#e8e8e8;}
.doc1 table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc1 table td {border:1px solid #000000; height:13px; padding:5px;}
.doc1 table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:5px; }
p {padding:1px 0 10px 0;}
.doc1 table td.pd{padding:3px;}
.doc table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:3px; }
.doc1 table th.ht{height:60px;}

.doc_a table {border:1px solid #000000; font-size:0.85em; width:100%;}
.doc_a table td.nor {padding:5px 10px 2px 10px;}
.doc_a table td.con {padding:0 10px 0 25px; line-height:10px;}
.cnum table {width:44%; border:1px solid #000000; font-size:0.85em;}
.cnum table td{border:1px solid #000000; height:12px; padding:3px;}
.cnum table th{background-color:#e8e8e8;}

table.doc_s {width:200px; padding:0px;}
table.doc_s td{padding:0px; height:15px;}
table.doc_s th{padding:0px;}
.left {text-align:left;}
.center {text-align:center;}
.right {text-align:right;}
.fs {font-size:0.9em; font-weight:normal;}
.fss {font-size:0.85em;}
.lineh {line-height:12px;}
.name {padding-top:10px; padding-bottom:7px; line-height:16px;}
.ht{height:60px;}
.point{background-color:#e1e1e1; padding-top:3px; font-weight:bold;}
.agree{padding:4px 0 4px 0; }

table.zero { border:0px; font-size:1.00em; text-align:right;}

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

select.tak20{width:350px;}

-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
<input type='hidden' name='cons_no' value='<%=cons_no%>'>
<input type='hidden' name='off_id' value='<%=cons.getOff_id()%>'>
<input type='hidden' name='off_nm' value='<%=cons.getOff_nm()%>'>
<input type='hidden' name='reg_code' value='<%=cons.getReg_code()%>'>
<input type='hidden' name='req_id' value='<%=doc.getUser_id1()%>'>
<input type='hidden' name='mng_id' value='<%=base.getMng_id()%>'>
<input type='hidden' name="doc_no" 	value="<%=doc.getDoc_no()%>">  
<input type='hidden' name="doc_bit" value="">
<input type='hidden' name="mode" value="">
<table width="680">
	<tr>
		<td><div align="center"><span class=style1>�� �� �� ī Ź �� �� �� ��</span></div></td>
	</tr>
	<tr>
		<td height=10></td>
	</tr>
	<tr>
		<td>&nbsp;<img src=/acar/images/logo_1.png></td>
	</tr>
	<tr>
		<td height=3></td>
	</tr>	
    <tr id=tr_cons<%=j%>_2 style="display:''"> 
      	<td class="doc"> 
	        <table>
			  	<tr>
				    <th width='13%'>Ź�۹�ȣ</td>
					<td>&nbsp;<%=cons_no%></td>
				    <th width='13%'>Ź�۾�ü</td>
					<td>&nbsp;<%=cons.getOff_nm()%></td>
			  	</tr>
	          	<tr> 
		            <th width='13%'>������ȣ</td>
		            <%
		            	String prev_car_no = cons.getCar_no();
		            	String car_no = "";
		            	
		            	if( prev_car_no.length() > 10 ){
		            		car_no = cs_db.getCarNo(cons_no, seq);
		            	}
		            	car_no = car_no == "" ? prev_car_no : car_no;
		            	
		            %>
		            <td width='37%'>&nbsp;<%=cons.getCar_no()%>		            
					  <input type='hidden' name="car_no" value='<%=cons.getCar_no()%>' size='15' class='<%=white%>text' readonly>
					  <input type='hidden' name='seq' value='<%=cons.getSeq()%>'>
					  <input type='hidden' name='car_mng_id' value='<%=cons.getCar_mng_id()%>'>
					  <input type='hidden' name='rent_mng_id' value='<%=cons.getRent_mng_id()%>'>
					  <input type='hidden' name='rent_l_cd' value='<%=cons.getRent_l_cd()%>'>
					  <input type='hidden' name='client_id' value='<%=cons.getClient_id()%>'>
					  <%if(white.equals("")){%>
					  <!--<span class="b"><a href='javascript:search_car(<%=j%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span>-->
					  <%}%>
					</td>
					<th width='13%'>����</td>
					<%-- <td width='37%'>&nbsp;<%=cons.getCar_nm()%>  <!--cars.getCar_nm() ���� ���� 20181022-->
					  <input type='hidden' name="car_nm" value='<%=cons.getCar_nm()%>' size='40' class='whitetext' readonly></td> --%>
					  <td width='37%'>&nbsp;<%=car_nm%>  <!--cars.getCar_nm() ���� ���� 20181022-->
					  <input type='hidden' name="car_nm" value='<%=car_nm%>' size='40' class='whitetext' readonly></td>
	          	</tr>
			  	<tr>
				    <th>����</td>
					<td>&nbsp;<%=car.getCar_y_form()%>
					  <input type='hidden' name="car_y_form" value='<%=car.getCar_y_form()%>' size='40' class='whitetext' readonly>
					</td>
				    <th>����</td>
					<td>&nbsp;<%=car_etc.getColo()%>
					  <input type='hidden' name="color" value='<%=car_etc.getColo()%>' size='40' class='whitetext' readonly></td>			
			  	</tr>
			</table>
	  	</td>
    </tr>
	<tr>
	  	<td align="right">&nbsp;</td>
	</tr>		
    <tr> 
      	<td class="doc"> 		
	        <table>
	          	<tr>
		            <th width=13% rowspan="2">����</td>
		            <th width=14%>������</td>
		            <th width=11%>�����</td>
		            <th width=12%>����</td>
		            <th width=13%>����</td>
		            <th width=12%>û��</td>
		            <th width=12%>����</td>
		            <th width=13%>����</td>
	          	</tr>
	          	<tr>
		            <td align="center"><%=sender_bean.getBr_nm()%></td>
		            <td align="center"><%=sender_bean.getUser_nm()%><br><%=doc.getUser_dt1()%></td>
		            <td align="center"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>&nbsp;</td>
		            <td align="center"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>&nbsp;</td>
		            <td align="center"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%>&nbsp;</td>
		            <td align="center"><%=c_db.getNameById(doc.getUser_id5(),"USER_PO")%><br><%=doc.getUser_dt5()%>&nbsp;</td>
		            <td align="center"><%=c_db.getNameById(doc.getUser_id6(),"USER_PO")%><br><%=doc.getUser_dt6()%>&nbsp;</td>
	          	</tr>
	        </table>
	  	</td>
    </tr>
	<tr id=tr_cons<%=j%>_3 style="display:''">
	  	<td class="doc" align="right">&nbsp;</td>
	</tr>	
    <tr id=tr_cons<%=j%>_4 style="display:''"> 
      	<td class="doc"> 
        	<table>	  
    		    <tr>
        		    <th width=13% colspan="2">�����</td>
        		    <td width="*" colspan="3">&nbsp;
					<%if(cons.getReq_id().equals("")) cons.setReq_id(doc.getUser_id1());%>

                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <%if(cons.getReq_id().equals(user.get("USER_ID"))){%><%=user.get("USER_NM")%><%if(user.get("DEPT_ID").equals("1000")){%>[������Ʈ]<%}%><%}%>
                        <%		}
        					}%>
                      <!-- ���Ƿ��� ǥ��(20190409) -->	
						<%if(!cons.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(cons.getAgent_emp_id()); %>&nbsp;�� �Ƿ��� : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%><%}%>
        			</td>			
    	        </tr>
				<tr>
					<th colspan="2">���������</td>
					<td>&nbsp;
						<%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
									<%if(base.getMng_id().equals(user.get("USER_ID"))){%><%=user.get("USER_NM")%><%}%>
						<%		}
							}%>
					</td>
					<th width=13%>Ź�۱���</td>
        		    <td width="*">&nbsp;
        			  <select class="tak20" name="cmp_app" <%=disabled%>>
        			   <option value="">����</option>
        			 	<%for(int i = 0 ; i < c_size2 ; i++){
        					Hashtable code2 = (Hashtable)codes2.elementAt(i);%>
        					<option value='<%=code2.get("NM_CD")%>' <%if(cons.getCmp_app().equals(String.valueOf(code2.get("NM_CD") ))){%>selected<%}%>><%=code2.get("NM")%></option>
        				<%}%>
          			  </select>
        			  <!--(��üŹ���϶�)-->
        			</td>
				</tr>
				<tr>
					<th colspan="2">Ź�ۻ���</td>
					<td colspan="3">&nbsp;
					  <select name="cons_cau" onChange="javascript:cng_input4(this.value, <%=j%>)" <%=disabled%>>
						<option value="">����</option>
						<%for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm_cd()%>' <%if(cons.getCons_cau().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
						<%}%>
					  </select>
					  <%if(!cons.getCons_cau_etc().equals("")){%>&nbsp;��Ÿ���� : <%=cons.getCons_cau_etc()%><%}%>
					  <input type='hidden' name="cons_cau_etc" value='<%=cons.getCons_cau_etc()%>' size='40' class='<%=white%>text'>
					    &nbsp;
					    <% if ( cons.getCons_cau().equals("1")) {%>
					    <% if (base.getCar_gu().equals("1")) { %><b>(����)</b><% } else if (base.getCar_gu().equals("3")){ %><b>(����Ʈ)</b> <%}else { %><b>(�縮��)</b><% } %>
					    <% } %>
					</td>
		      	</tr>
			  	<tr>
				    <th colspan="2">��뱸��</td>
					<td>&nbsp;
					  <select name="cost_st" <%=disabled%>>
					    <option value="">����</option>
					    <option value="1" <%if(cons.getCost_st().equals("1")){%>selected<%}%>>�Ƹ���ī</option>
					    <option value="2" <%if(cons.getCost_st().equals("2")){%>selected<%}%>>��</option>								
		  			  </select>
					</td>						
				    <th>���ޱ���</td>
					<td>&nbsp;
					  <select name="pay_st" <%=disabled%>>
					    <option value="">����</option>
					    <option value="1" <%if(cons.getPay_st().equals("1")){%>selected<%}%>>����</option>
					    <option value="2" <%if(cons.getPay_st().equals("2")){%>selected<%}%>>�ĺ�</option>								
		  			  </select>
					</td>						
	     	 	</tr>
		  		<tr>
				    <th width="3%" rowspan="4">��<br>
			        û</td>
				    <th width="10%">����</td>
				    <td colspan="3">&nbsp;
					  <select name="wash_yn" <%=disabled%>>
					    <option value="">����</option>
					    <option value="Y" <%if(cons.getWash_yn().equals("Y")){%>selected<%}%>>��û</option>
					    <option value="N" <%if(cons.getWash_yn().equals("N")){%>selected<%}%>>����</option>								
		  			  </select>
					</td>
	      		</tr>
		  		<tr>
				    <th>����</td>
				    <td colspan="3">&nbsp;
					  <select name="oil_yn" <%=disabled%>>
					    <option value="">����</option>
					    <option value="Y" <%if(cons.getOil_yn().equals("Y")){%>selected<%}%>>��û</option>
					    <option value="N" <%if(cons.getOil_yn().equals("N")){%>selected<%}%>>����</option>								
		  			  </select>
					  <%if(cons.getOil_yn().equals("Y")){%>
						������û -&gt; 
					  <%=Util.parseDecimal(cons.getOil_liter())%><input type='hidden' name="oil_liter" value='<%=Util.parseDecimal(cons.getOil_liter())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
						����<!--��--> 
						Ȥ��
					  <%=Util.parseDecimal(cons.getOil_est_amt())%><input type='hidden' name="oil_est_amt" value='<%=Util.parseDecimal(cons.getOil_est_amt())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
						����ġ ���� ���ּ���.
					  <%}%>
					</td>
	      		</tr>
	      		<tr>
				    <th>�����н�<br>���</td>
				    <td colspan="3">&nbsp;
					  <select name="hipass_yn">
		        			    <option value="Y" <%if(cons.getHipass_yn().equals("Y")){%>selected<%}%>>��û</option>
		        			    <option value="N" <%if(cons.getHipass_yn().equals("N")||cons.getHipass_yn().equals("")){%>selected<%}%>>����</option>								
		          			  </select>
							  (��ϴ��� �Ƿڽ� �����Ͻʽÿ�.)
					</td>
	      		</tr>
		  		<tr>
				    <th>��Ÿ</td>
				    <td colspan="3" style="height:50px;">&nbsp;
		              <%=cons.getEtc()%><!--<textarea rows='5' cols='90' name='etc' class='<%=white%>'></textarea>--></td>
	      		</tr>		  
			</table>
	  	</td>
	</tr>  	  
	<tr>
	  	<td align="right">&nbsp;</td>
	</tr>			
    <tr> 
      	<td class="doc"> 
        	<table>	  		  
		  		<tr>
				    <th width="3%" rowspan="8">��<br>��</td>
				    <th width="10%">����</td>
				    <td width="37%">&nbsp;
					  <select name="from_st" onChange="javascript:cng_input3('from', this.value, <%=j%>)" <%=disabled%>>
					    <option value="">����</option>
					    <option value="1" <%if(cons.getFrom_st().equals("1")){%>selected<%}%>>�Ƹ���ī</option>
					    <option value="2" <%if(cons.getFrom_st().equals("2")){%>selected<%}%>>��</option>
					    <option value="3" <%if(cons.getFrom_st().equals("3")){%>selected<%}%>>���¾�ü</option>				
		  			  </select>
					  <%if(white.equals("")){%>		
					  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span>
					  <%}%>
					</td>
				    <th width="3%" rowspan="8">��<br>��</td>
				    <th width="10%">����</td>
				    <td width="37%">&nbsp;
					  <select name="to_st" onChange="javascript:cng_input3('to', this.value, <%=j%>)" <%=disabled%>>
					    <option value="">����</option>
					    <option value="1" <%if(cons.getTo_st().equals("1")){%>selected<%}%>>�Ƹ���ī</option>
					    <option value="2" <%if(cons.getTo_st().equals("2")){%>selected<%}%>>��</option>
					    <option value="3" <%if(cons.getTo_st().equals("3")){%>selected<%}%>>���¾�ü</option>				
		  			  </select>
					  <%if(white.equals("")){%>			
					  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span>
					  <%}%>
					</td>			
		  		</tr>
		  		<tr>
				    <th width="10%">���</td>
				    <td>&nbsp;<%=cons.getFrom_place()%>
		                <input type='hidden' name="from_place" value='<%=cons.getFrom_place()%>' size='40' class='<%=white%>text' ></td>
				    <th width="10%">���</td>
				    <td>&nbsp;<%=cons.getTo_place()%>
		                <input type='hidden' name="to_place" value='<%=cons.getTo_place()%>' size='40' class='<%=white%>text' ></td>
		  		</tr>
		  		<tr>
				    <th>��ȣ/����</td>
				    <td>&nbsp;<%=cons.getFrom_comp()%>
		                <input type='hidden' name="from_comp" value='<%=cons.getFrom_comp()%>' size='40' class='<%=white%>text' >
						</td>
				    <th>��ȣ/����</td>
				    <td>&nbsp;<%=cons.getTo_comp()%>
		                <input type='hidden' name="to_comp" value='<%=cons.getTo_comp()%>' size='40' class='<%=white%>text' ></td>
		  		</tr>
		  		<tr>
				    <th>�����</td>
			        <td>&nbsp;�μ�/����:<%=cons.getFrom_title()%>
			          <input type='hidden' name="from_title" value='<%=cons.getFrom_title()%>' size='13' class='<%=white%>text'>
		              &nbsp;����:<%=cons.getFrom_man()%>
		              <input type='hidden' name="from_man" value='<%=cons.getFrom_man()%>' size='8' class='<%=white%>text' >
					  <%if(white.equals("")){%>
					  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span>
					  <%}%>
					</td>
				    <th>�����</td>
				    <td>&nbsp;�μ�/����:<%=cons.getTo_title()%>
				      <input type='hidden' name="to_title" value='<%=cons.getTo_title()%>' size='13' class='<%=white%>text' >
					  &nbsp;����:<%=cons.getTo_man()%>
					  <input type='hidden' name="to_man" value='<%=cons.getTo_man()%>' size='8' class='<%=white%>text' >
					  <%if(white.equals("")){%>
					  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span>
					  <%}%>
					</td>
		  		</tr>
		  		<tr>
				    <th>����ó</td>
				    <td>&nbsp;<%=cons.getFrom_tel()%>
		                <input type='hidden' name="from_tel" value='<%=cons.getFrom_tel()%>' size='15' class='<%=white%>text' >
						&nbsp;�ڵ���:&nbsp;<%=cons.getFrom_m_tel()%>
		                <input type='hidden' name="from_m_tel" value='<%=cons.getFrom_m_tel()%>' size='15' class='<%=white%>text' >
					</td>
				    <th>����ó</td>
				    <td>&nbsp;<%=cons.getTo_tel()%>
		                <input type='hidden' name="to_tel" value='<%=cons.getTo_tel()%>' size='15' class='<%=white%>text' >
						&nbsp;�ڵ���: <%=cons.getTo_m_tel()%>
		                <input type='hidden' name="to_m_tel" value='<%=cons.getTo_m_tel()%>' size='15' class='<%=white%>text' >
					</td>
		  		</tr>
		  		<tr>
				    <th>��û�Ͻ�</td>
				    <td>&nbsp;
					  <%	String from_req_dt = "";
					  		String from_req_h = "";
							String from_req_s = "";
					  		if(cons.getFrom_req_dt().length() == 12){
								from_req_dt = cons.getFrom_req_dt().substring(0,8);
								from_req_h 	= cons.getFrom_req_dt().substring(8,10);
								from_req_s	= cons.getFrom_req_dt().substring(10,12);
							}%>
		              <input type='text' name="from_req_dt" value='<%=AddUtil.ChangeDate2(from_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt[<%=j%>].value=this.value;'>
		              &nbsp;
					  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=j%>].value=this.value;" <%=disabled%>>
		                <%for(int i=0; i<24; i++){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
		              <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;" <%=disabled%>>
		                <%for(int i=0; i<59; i+=5){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
		            </td>
				    <th>��û�Ͻ�</td>
				    <td>&nbsp;
					  <%	String to_req_dt = "";
					  		String to_req_h = "";
							String to_req_s = "";
					  		if(cons.getTo_req_dt().length() == 12){
								to_req_dt 	= cons.getTo_req_dt().substring(0,8);
								to_req_h 	= cons.getTo_req_dt().substring(8,10);
								to_req_s 	= cons.getTo_req_dt().substring(10,12);
							}%>			
		              <input type='text' name="to_req_dt" value='<%=AddUtil.ChangeDate2(to_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value)'>
		              &nbsp;
					  <select name="to_req_h" <%=disabled%>>
		                <%for(int i=0; i<24; i++){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
		              <select name="to_req_s" <%=disabled%>>
		                <%for(int i=0; i<59; i+=5){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
		            </td>
	      		</tr>
		  		<tr>
				    <th>�����Ͻ�</td>
				    <td>&nbsp;
					  <%	String from_est_dt = "";
					  		String from_est_h = "";
							String from_est_s = "";
					  		if(cons.getFrom_est_dt().length() == 12){
								from_est_dt = cons.getFrom_est_dt().substring(0,8);
								from_est_h 	= cons.getFrom_est_dt().substring(8,10);
								from_est_s	= cons.getFrom_est_dt().substring(10,12);
							}%>			
		              <input type='text' name="from_est_dt" value='<%=AddUtil.ChangeDate2(from_est_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_est_dt[<%=j%>].value=this.value;'>
					  &nbsp;
					  <select name="from_est_h" <%=disabled%>>
		                <%for(int i=0; i<24; i++){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_est_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
		              <select name="from_est_s" <%=disabled%>>
		                <%for(int i=0; i<59; i+=5){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_est_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
					  </td>
			        <th>�����Ͻ�</td>
			        <td>&nbsp;
					  <%	String to_est_dt = "";
					  		String to_est_h = "";
							String to_est_s = "";
					  		if(cons.getTo_est_dt().length() == 12){
								to_est_dt 	= cons.getTo_est_dt().substring(0,8);
								to_est_h 	= cons.getTo_est_dt().substring(8,10);
								to_est_s 	= cons.getTo_est_dt().substring(10,12);
							}%>						
		              <input type='text' name="to_est_dt" value='<%=AddUtil.ChangeDate2(to_est_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value);'>
					  &nbsp;
					  <select name="to_est_h" <%=disabled%>>
		                <%for(int i=0; i<24; i++){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
		              <select name="to_est_s" <%=disabled%>>
		                <%for(int i=0; i<59; i+=5){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
					</td>
		  		</tr>
		  		<tr>
				    <th>�μ��Ͻ�</td>
				    <td>&nbsp;
					  <%	String from_dt = "";
					  		String from_h = "";
							String from_s = "";
					  		if(cons.getFrom_dt().length() == 12){
								from_dt = cons.getFrom_dt().substring(0,8);
								from_h 	= cons.getFrom_dt().substring(8,10);
								from_s	= cons.getFrom_dt().substring(10,12);
							}%>			
		              <input type='text' name="from_dt" value='<%=AddUtil.ChangeDate2(from_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_est_dt[<%=j%>].value=this.value;'>
					  &nbsp;
					  <select name="from_h" <%=disabled%>>
		                <%for(int i=0; i<24; i++){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
		              <select name="from_s" <%=disabled%>>
		                <%for(int i=0; i<59; i+=5){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
					  </td>
			        <th>�ε��Ͻ�</td>
			        <td>&nbsp;
					  <%	String to_dt = "";
					  		String to_h = "";
							String to_s = "";
					  		if(cons.getTo_dt().length() == 12){
								to_dt 	= cons.getTo_dt().substring(0,8);
								to_h 	= cons.getTo_dt().substring(8,10);
								to_s 	= cons.getTo_dt().substring(10,12);
							}%>						
		              <input type='text' name="to_dt" value='<%=AddUtil.ChangeDate2(to_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value);'>
					  &nbsp;
					  <select name="to_h" <%=disabled%>>
		                <%for(int i=0; i<24; i++){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
		              <select name="to_s" <%=disabled%>>
		                <%for(int i=0; i<59; i+=5){%>
		                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
		                <%}%>
		              </select>
					</td>
		  		</tr>
			</table>
	  	</td>
	</tr>  	  
	<tr>
	  	<td align="right">&nbsp;</td>
	</tr>			
    <tr> 
      	<td class="doc"> 
	        <table>	  		  		  
			  	<tr>
				    <th width="13%">�����ڸ�</td>
		            <td width="37%">&nbsp;<%=cons.getDriver_nm()%>
		                <input type='hidden' name="driver_nm" value='<%=cons.getDriver_nm()%>' size='15' class='<%=white%>text'>
					</td>
		            <th width="13%">�������ڵ���</td>
		            <td width="37%">&nbsp;<%=cons.getDriver_m_tel()%>
		            <input type='hidden' name="driver_m_tel" value='<%=cons.getDriver_m_tel()%>' size='15' class='<%=white%>text'></td>
		      	</tr>		  
	        </table>
      	</td>
    </tr>		
	<tr>
	  	<td align="right">&nbsp;</td>
	</tr>	
    <tr> 
      	<td class="doc"> 
	        <table>
			  	<tr>
				    <th width="13%">Ź�۷�</td>
			        <th width="10%">������</td>
				    <th width="10%">������</td>
				    <th width="17%">��Ÿ����</td>
				    <th width="13%">��Ÿ�ݾ�</td>
				    <th width="13%">�Ұ�</td>
				    <th width="12%">û������</td>
				    <th width="12%">��������</td>						
			  	</tr>
			  	<tr>
				    <td align="center"><%=AddUtil.parseDecimal(cons.getCons_amt())%><input type='hidden' name="cons_amt" value='<%=AddUtil.parseDecimal(cons.getCons_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
				    <td align="center"><%=AddUtil.parseDecimal(cons.getOil_amt())%><input type='hidden' name="oil_amt" value='<%=AddUtil.parseDecimal(cons.getOil_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
				    <td align="center"><%=AddUtil.parseDecimal(cons.getWash_amt())%><input type='hidden' name="wash_amt" value='<%=AddUtil.parseDecimal(cons.getWash_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
				    <td align="center"><%=cons.getOther()%><input type='hidden' name="other" value='<%=cons.getOther()%>' size='10' class='<%=white%>text'></td>
				    <td align="center"><%=AddUtil.parseDecimal(cons.getOther_amt())%><input type='hidden' name="other_amt" value='<%=AddUtil.parseDecimal(cons.getOther_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
				    <td align="center"><%=AddUtil.parseDecimal(cons.getTot_amt())%><input type='hidden' name="tot_amt" value='<%=AddUtil.parseDecimal(cons.getTot_amt())%>' size='7' class='<%=white%>num'></td>
				    <td align="center"><%=AddUtil.ChangeDate2(cons.getReq_dt())%><input type='hidden' name="req_dt" value='<%=AddUtil.ChangeDate2(cons.getReq_dt())%>' size='10' class='<%=white%>text'></td>
				    <td align="center"><%=AddUtil.ChangeDate2(cons.getPay_dt())%><input type='hidden' name="pay_dt" value='<%=AddUtil.ChangeDate2(cons.getPay_dt())%>' size='10' class='<%=white%>text'></td>						
			  	</tr>
			</table>
	  	</td>
    </tr>		
	<tr>
	  	<td align="right">&nbsp;</td>
	</tr>	
	<%if(cons.getCost_st().equals("2")){%>
    <tr> 
      	<td class="doc"> 
	        <table>
			  	<tr>
				    <th width="13%"><font color=red><b>��Ź�۷�</b></font></td>
			        <td width="37%">&nbsp;<%=AddUtil.parseDecimal(cons.getCust_amt())%>
					  <input type='hidden' name="cust_amt" value='<%=AddUtil.parseDecimal(cons.getCust_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
				    <th width="13%">��������</td>
				    <td width="37%">&nbsp;<%=AddUtil.ChangeDate2(cons.getCust_pay_dt())%>
					  <input type='hidden' name="cust_pay_dt" value='<%=AddUtil.ChangeDate2(cons.getCust_pay_dt())%>'></td>
		      	</tr>
			</table>
	  	</td>
    </tr>		
	<tr>
	  	<td align="right">&nbsp;</td>
	</tr>				
	<%}%>
	<tr>
	  	<td align="right"><a href="javascript:print()"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a></td>
	</tr>			
	<tr>
	  	<td align="right">&nbsp;</td>
	</tr>				
	<tr>
	  	<td><font color=#555555>&nbsp;���μ�TIP : ����Ʈ�� ���ͳ� �ͽ��÷ξ� ȭ�� ��ܿ� �޴��� '����>���ͳݿɼ�>���(��ܸǿ���)>�μ�>���� ��<br>
	  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �̹��� �μ�'�� üũ �Ǿ��־�� �ùٸ��� �μ�˴ϴ�.</font></td>
	</tr>			
	<tr>
	  	<td><font color=#555555>&nbsp;������������ : ����Ʈ�� ���ͳ� �ͽ��÷ξ� ȭ�� ��ܿ� �޴��� �������������� �Ӹ���/�ٴڱ� �������� �����ϰ�<br>
	  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �μ�˴ϴ�.</font></td>
	</tr>			
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;	
//-->
</script>
</body>
</html>
