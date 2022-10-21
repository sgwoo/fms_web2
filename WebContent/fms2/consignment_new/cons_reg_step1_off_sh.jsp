<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %> 


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "22", "01");	
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String sub_l_cd 	= request.getParameter("sub_l_cd")==null?"":request.getParameter("sub_l_cd");
	String sub_c_id 	= request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
			
	String off_id 	= request.getParameter("off_id")  ==null?""   :request.getParameter("off_id");
	String off_nm 	= request.getParameter("off_nm")  ==null?""   :request.getParameter("off_nm");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
				
	String display = "";
	String cons_cau = "";
	String cost_st = "1";
	String pay_st = "2";
	
	String white = "";
	String disabled = "";
	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	//Ź�۾�ü ��ȸ
	function search_off()
	{
		var fm = document.form1;	
		
		window.open("/acar/cus0601/cus0602_frame.jsp?from_page=/fms2/consignment_new/cons_i_c.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=650, scrollbars=yes, status=yes, resizable=yes");
	}		
	
		//Ź�۾�ü ����
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� Ź�۾�ü�� �����ϴ�."); return;}
		window.open("/acar/cus0601/cus0602_d_frame.jsp?from_page=/fms2/consignment_new/cons_i_c.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=260, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	
	function cng_code_22(){
		var fm = document.form1;

		drop_deposit();
				
		fm.target='i_no';
		fm.action='/fms2/consignment_new/get_code_22t_nodisplay.jsp?off_id='+fm.off_id.value;

		fm.submit();
	}	
	
	function drop_deposit(){
		var fm = document.form1;					
	
		var deposit_len = fm.cmp_app.length;			
		for(var i = 0 ; i < deposit_len ; i++){
			fm.cmp_app.options[deposit_len-(i+1)] = null;
		}		
		
	}
	
	function add_deposit(idx, val, str){

		document.form1.cmp_app[idx] = new Option(str, val);		
	}
		
	//���/���� ���п� ���� �˾�
	function cng_input3(st, value){
		var fm = document.form1;		
		var width = 600;
		var firm_nm = '';				
		var req_id 	= fm.req_id.value;
		var s_kd 	= '1';
	   var chk_client = '';		
	  				
		  	  			
		if(st == 'from' && fm.from_st.value == ''){		alert('��� ������ �����Ͻʽÿ�.'); 	return;		}
		if(st == 'to' && fm.to_st.value == ''){			alert('���� ������ �����Ͻʽÿ�.'); 	return;		}		
				
		if(value == '2'){ 
			width 	= 800;
			firm_nm = fm.firm_nm.value;
		
		}
					
		window.open("s_place.jsp?chk_client="+chk_client+"&go_url=/fms2/consignment_new/cons_reg_step1_off_sh.jsp&st="+st+"&value="+value+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&req_id=''", "PLACE", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//���/���� ����� ��ȸ
	function cng_input5(st, value){
		var fm = document.form1;		
		var width = 600;
		var firm_nm = '';
		
		if(st == 'from' && fm.from_st.value == ''){		alert('��� ������ �����Ͻʽÿ�.'); 	return;		}
		if(st == 'to' && fm.to_st.value == ''){			alert('���� ������ �����Ͻʽÿ�.'); 	return;		}

		if(st == 'from')		firm_nm 	= fm.from_comp.value;
		if(st == 'to')			firm_nm 	= fm.to_comp.value;
		
		if(firm_nm == ''){ 		alert('������ �����Ͽ� ��Ҹ� ���� �����Ͽ� �ֽʽÿ�.'); 	return; }
		
		if(value == '1') 		firm_nm 	= replaceString('(��)�Ƹ���ī ','',firm_nm);
		
		if(value == '3'){		alert('���¾�ü�� ����� �˻��� �����ϴ�.');	return; }
		
		window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step1_off_sh.jsp&st="+st+"&value="+value+"&s_kd=1&t_wd="+firm_nm+"&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&car_no="+fm.car_no[idx].value, "MAN", "left=10, top=10, width="+width+", height=500, scrollbars=yes, status=yes, resizable=yes");		
	}			
		
//���˻��ϱ�
	function find_cont_search(){
		var fm = document.form1;
		if(fm.off_nm.value == '') { alert('Ź�۾�ü�� Ȯ���Ͻʽÿ�.'); return; }
		window.open("find_cont_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&off_id="+fm.off_id.value+"&t_wd="+fm.off_nm.value, "SEARCH_FINE", "left=50, top=50, width=1080, height=700, scrollbars=no");
	}		
			
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">

<form  name="form1" method='post'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='cons_kd' value='1'> <!--Ź�ۺз� --> 
 <input type='hidden' name='cons_st' value='1'> <!--�� --> 

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > Ź�۰��� > <span class=style5>���(�Ÿ�)Ź���Ƿڵ��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
  
    <tr>
        <td class=line2></td>
    </tr>
    
      <tr>
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				
				  <tr> 
                   <td width='13%' class='title' colspan="2">Ź�۾�ü</td>
                    <td colspan="5">&nbsp;
        			  <input type='text' name="off_nm" value='<%=off_nm%>' size='30' class='text'>
        			  <input type='hidden' name='off_id' value='<%=off_id%>'>
        			  <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			  <span class="b"><a href="javascript:view_off()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			</td>
              </tr> 
              
    		    <tr>
        		    <td colspan="2" class='title'>�Ƿ���</td>
        		    <td >&nbsp;
        			  <select name='req_id'>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
        		    <td colspan="2" class='title'>Ź�۱���</td>
        		    <td>&nbsp;        		    
        		    <!-- ������ ��� �ʼ����� : ��� setting -->
        			  <select name="cmp_app">
        			        <option value=''>Ź�۱����� �����ϼ���</option>
        			     </td>        		
    	        </tr>				
    		    <tr>
        		    <td colspan="2" class='title'>Ź�ۻ���</td>
        		    <td colspan="4">&nbsp;
        			  <select name="cons_cau" >
        			    <option value="">����</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>' <%if(cons_cau.equals(code.getNm_cd()))%>selected<%%>><%=code.getNm()%></option>
        				<%}%>
          			  </select>
        			  &nbsp;��Ÿ���� : <input type='text' name="cons_cau_etc" value='' size='40' class='text'>
        			  &nbsp;<font color="#666666">(�ѱ� 25�� �̳�)</font>
        			</td>
    	        </tr>
    	       
    		    <tr>
        		    <td colspan="2" class='title'>��뱸��</td>
        			<td>&nbsp;
        			  <select name="cost_st">
        			    <option value="">����</option>
        			    <option value="1" <%if(cost_st.equals("1"))%>selected<%%>>�Ƹ���ī</option>
        			    <option value="2" <%if(cost_st.equals("2"))%>selected<%%>>��</option>								
          			  </select>
        			  &nbsp;<font color=red>[���δ�]Ź�۷� : <input type='text' name="cust_amt" value='0' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>��</font>
        			</td>						
        		    <td colspan="2" class='title'>���ޱ���</td>
        			<td>&nbsp;
        			  <select name="pay_st">
        			    <option value="">����</option>
        			    <option value="1" <%if(pay_st.equals("1"))%>selected<%%>>����</option>
        			    <option value="2" <%if(pay_st.equals("2"))%>selected<%%>>�ĺ�</option>								
          			  </select>
        			</td>						
    	        </tr> 
    	         
    		 
    		    <tr>
    		      <input type='hidden' name="other"  > 
        		    <td colspan="2" class='title'>��Ÿ</td>
        		    <td colspan="4">&nbsp;
                      <textarea rows='5' cols='90' name='etc' style="color:red"></textarea></td>
    	        </tr>		  
    		    <tr>
        		    <td width="3%" rowspan="6" class='title'>��<br>��</td>
        		    <td width="10%" class='title'>����</td>
        		    <td width="37%">&nbsp;
        			  <select name="from_st"  style="width:150px;" onChange="javascript:cng_input3('from', this.value)">
        			    <option value="">����</option>
        			    <option value="1">�Ƹ���ī</option>
        	
        			    <option value="3">���¾�ü</option>
        			    <option value="4">�������</option>				
          			  </select>		
        			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st.options[document.form1.from_st.selectedIndex].value)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td width="3%" rowspan="6" class='title'>��<br>��</td>
        		    <td width="10%" class='title'>����</td>
        		    <td width="37%">&nbsp;
        			  <select name="to_st"  style="width:150px;" onChange="javascript:cng_input3('to', this.value)">
        			    <option value="">����</option>
        			    <option value="1">�Ƹ���ī</option>
        		
        			    <option value="3">���¾�ü</option>				
          			  </select>			
        			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st.options[document.form1.to_st.selectedIndex].value)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>			
    		    </tr>
    		    <tr>
        		    <td width="10%" class='title'>���</td>
        		    <td>&nbsp;
                        <input type='text' name="from_place" id="from_place" value='' size='40' class='text' ></td>
        		    <td width="10%" class='title'>���</td>
        		    <td>&nbsp;
                        <input type='text' name="to_place" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>��ȣ/����</td>
        		    <td>&nbsp;
                        <input type='text' name="from_comp" id="from_comp" value='' size='40' class='text' >
        				</td>
        		    <td class='title'>��ȣ/����</td>
        		    <td>&nbsp;
                        <input type='text' name="to_comp" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>�����</td>
        	        <td>&nbsp;�μ�/����
        	          <input type='text' name="from_title" id="from_title" value='' size='20' class='text' ><br>
                      &nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type='text' name="from_man" id="from_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st.options[document.form1.from_st.selectedIndex].value)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td class='title'>�����</td>
        		    <td>&nbsp;�μ�/����
        		      <input type='text' name="to_title" value='' size='20' class='text' ><br>
        			  &nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <input type='text' name="to_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st.options[document.form1.to_st.selectedIndex].value)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>����ó</td>
        		    <td>&nbsp;�繫��
                        <input type='text' name="from_tel" id="from_tel" value='' size='15' class='text' ><br>
        				&nbsp;�ڵ���
                        <input type='text' name="from_m_tel" id="from_m_tel" value='' size='15' class='text' >
        			</td>
        		    <td class='title'>����ó</td>
        		    <td>&nbsp;�繫��
                        <input type='text' name="to_tel" value='' size='15' class='text' ><br>
        				&nbsp;�ڵ���
                        <input type='text' name="to_m_tel" value='' size='15' class='text' >
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>��û�Ͻ�</td>
        		    <td>&nbsp;
                      <input type='text' name="from_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt.value=this.value;'>
                      &nbsp;
        			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h.value=this.value;">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="from_req_s" onchange="javascript:document.form1.to_req_s.value=this.value;">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
        		    <td class='title'>��û�Ͻ�</td>
        		    <td>&nbsp;
                      <input type='text' name="to_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;
        			  <select name="to_req_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="to_req_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
    	        </tr>    		   
				
            </table>
        </td>
    </tr>
   
    <tr>
        <td class=h></td>
    </tr>		
	
	 <tr> 
        <td><a href="javascript:find_cont_search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
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