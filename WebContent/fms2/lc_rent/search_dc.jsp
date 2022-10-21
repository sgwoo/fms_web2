<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");


	//����DC ������
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")	==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");
	int car_fs_amt 		= request.getParameter("car_fs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fs_amt"));
	int car_fv_amt 		= request.getParameter("car_fv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fv_amt"));
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CodeBean[] codes = c_db.getCodeAll("0017");
	int c_size = codes.length;
	
		
	int car_amt = car.getCar_fs_amt()+car.getCar_fv_amt();
	
	if(car_fs_amt>0){
		car_amt = car_fs_amt+car_fv_amt;
	}
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//�Һ��ڰ���� �ݾװ��
	function setDc_per_amt(obj, idx){
		obj.value = obj.value;
		var fm = document.form1;
		
		if(idx == 1){
			if(obj==fm.s_dc1_per){
				fm.s_dc1_amt.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * toFloat(fm.s_dc1_per.value) /100 ) );
			}else if(obj==fm.s_dc1_amt){
				fm.s_dc1_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc1_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			}
		}
		if(idx == 2){
			if(obj==fm.s_dc2_per){
				fm.s_dc2_amt.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * toFloat(fm.s_dc2_per.value) /100) );
			}else if(obj==fm.s_dc2_amt){
				fm.s_dc2_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc2_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			}
		}
		if(idx == 3){
			if(obj==fm.s_dc3_per){
				fm.s_dc3_amt.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * toFloat(fm.s_dc3_per.value) /100));
			}else if(obj==fm.s_dc3_amt){
				fm.s_dc3_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc3_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			}
		}
	}
	
	function save()
	{
		var fm = document.form1;

		if(	toInt(parseDigit(fm.s_dc1_amt.value))>0 && fm.s_dc1_re.value == ''){ alert('����D/C ����1�� �Է��Ͻʽÿ�.'); return; }
		if(	toInt(parseDigit(fm.s_dc2_amt.value))>0 && fm.s_dc2_re.value == ''){ alert('����D/C ����2�� �Է��Ͻʽÿ�.'); return; }
		if(	toInt(parseDigit(fm.s_dc3_amt.value))>0 && fm.s_dc3_re.value == ''){ alert('����D/C ����3�� �Է��Ͻʽÿ�.'); return; }		
		
		if(fm.s_dc1_re.value == '��Ÿ' && fm.s_dc1_re_etc.value == ''){ alert('����D/C ������ ��Ÿ�� ���� ��Ÿ������ �Է��Ͻʽÿ�.'); return; } 		
		if(fm.s_dc2_re.value == '��Ÿ' && fm.s_dc2_re_etc.value == ''){ alert('����D/C ������ ��Ÿ�� ���� ��Ÿ������ �Է��Ͻʽÿ�.'); return; } 		
		if(fm.s_dc3_re.value == '��Ÿ' && fm.s_dc3_re_etc.value == ''){ alert('����D/C ������ ��Ÿ�� ���� ��Ÿ������ �Է��Ͻʽÿ�.'); return; } 						
			
		window.opener.form1.s_dc1_re.value 		= fm.s_dc1_re.value;
		window.opener.form1.s_dc1_yn.value 		= fm.s_dc1_yn.value;
		window.opener.form1.s_dc1_amt.value 	= fm.s_dc1_amt.value;
		window.opener.form1.s_dc2_re.value 		= fm.s_dc2_re.value;
		window.opener.form1.s_dc2_yn.value 		= fm.s_dc2_yn.value;
		window.opener.form1.s_dc2_amt.value 	= fm.s_dc2_amt.value;
		window.opener.form1.s_dc3_re.value 		= fm.s_dc3_re.value;
		window.opener.form1.s_dc3_yn.value 		= fm.s_dc3_yn.value;
		window.opener.form1.s_dc3_amt.value 	= fm.s_dc3_amt.value;
		
		window.opener.form1.s_dc1_re_etc.value 	= fm.s_dc1_re_etc.value;
		window.opener.form1.s_dc2_re_etc.value 	= fm.s_dc2_re_etc.value;
		window.opener.form1.s_dc3_re_etc.value 	= fm.s_dc3_re_etc.value;						
		
		window.opener.form1.s_dc1_per.value 	= fm.s_dc1_per.value;
		window.opener.form1.s_dc2_per.value 	= fm.s_dc2_per.value;
		window.opener.form1.s_dc3_per.value 	= fm.s_dc3_per.value;				
		
		window.opener.form1.dc_c_amt.value 		= parseDecimal(toInt(parseDigit(fm.s_dc1_amt.value)) + toInt(parseDigit(fm.s_dc2_amt.value)) + toInt(parseDigit(fm.s_dc3_amt.value)) );		
		window.opener.form1.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(window.opener.form1.dc_c_amt.value))));
		window.opener.form1.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(window.opener.form1.dc_c_amt.value)) - toInt(parseDigit(window.opener.form1.dc_cs_amt.value)));

		window.opener.sum_car_f_amt();
		
		window.close();
	}
	
	//���� �ڵ庯ȯ
  	function set_dc_re(idx){
		var fm = document.form1;
		if(idx == 1){
			if(fm.s_dc1_re.value == "1")				fm.s_dc1_re.value = '�Ǹ�����������';
    		else if(fm.s_dc1_re.value  == "2")      	fm.s_dc1_re.value = '������';
    		else if(fm.s_dc1_re.value  == "3")      	fm.s_dc1_re.value = '������';
    		else if(fm.s_dc1_re.value  == "4")      	fm.s_dc1_re.value = '�ٷ�����ó���';
    		else if(fm.s_dc1_re.value  == "5")      	fm.s_dc1_re.value = 'ķ����';									    					
		}
		if(idx == 2){
			if(fm.s_dc2_re.value == "1")				fm.s_dc2_re.value = '�Ǹ�����������';
    		else if(fm.s_dc2_re.value  == "2")      	fm.s_dc2_re.value = '������';
    		else if(fm.s_dc2_re.value  == "3")      	fm.s_dc2_re.value = '������';
    		else if(fm.s_dc2_re.value  == "4")      	fm.s_dc2_re.value = '�ٷ�����ó���';
    		else if(fm.s_dc2_re.value  == "5")      	fm.s_dc2_re.value = 'ķ����';									    					
		}
		if(idx == 3){
			if(fm.s_dc3_re.value == "1")				fm.s_dc3_re.value = '�Ǹ�����������';
    		else if(fm.s_dc3_re.value  == "2")      	fm.s_dc3_re.value = '������';
    		else if(fm.s_dc3_re.value  == "3")      	fm.s_dc3_re.value = '������';
    		else if(fm.s_dc3_re.value  == "4")      	fm.s_dc3_re.value = '�ٷ�����ó���';
    		else if(fm.s_dc3_re.value  == "5")      	fm.s_dc3_re.value = 'ķ����';									    					
		}
  	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
<!--
.style1 {color: #333333}
-->
</style>
</head>
<body onload="javascript:document.form1.s_dc1_re.focus();">
<p>
<form name='form1' action='search_mgr.jsp' method='post'>
  <input type='hidden' name="car_f_amt" 		value="<%=car_amt%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>����D/C</span></span></td>
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
					<td class='title' width=5%> ���� </td>
					<td class='title' width='18%'>����</td>
					<td class='title'>����</td>					
					<td class='title' width='15%'>�Һ��ڰ����</td>										
					<td width="15%" class='title'>�뿩��ݿ�����</td>
				    <td width="15%" class='title'>�ݾ�</td>
			    </tr>
				<tr>
					<td align='center'>1</td>
					<td align="center">
					  <select name='s_dc1_re'>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc1_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc1_re_etc' size='30' class="text" value='<%=car.getS_dc1_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc1_per' size='4' class="text" value='<%=car.getS_dc1_per()%>' onBlur='javascript:setDc_per_amt(this, 1);'>%
					</td>
					<td align="center"><select name='s_dc1_yn'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc1_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc1_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc1_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc1_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setDc_per_amt(this, 1);'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>2</td>
					<td align="center">
					  <select name='s_dc2_re'>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc2_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc2_re_etc' size='30' class="text" value='<%=car.getS_dc2_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc2_per' size='4' class="text" value='<%=car.getS_dc2_per()%>' onBlur='javascript:setDc_per_amt(this, 2);'>%
					</td>					
					<td align="center"><select name='s_dc2_yn'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc2_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc2_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc2_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc2_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setDc_per_amt(this, 2);'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>3</td>
					<td align="center">
					  <select name='s_dc3_re'>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc3_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc3_re_etc' size='30' class="text" value='<%=car.getS_dc3_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc3_per' size='4' class="text" value='<%=car.getS_dc3_per()%>' onBlur='javascript:setDc_per_amt(this, 3);'>%
					</td>										
					<td align="center"><select name='s_dc3_yn'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc3_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc3_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc3_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc3_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setDc_per_amt(this, 3);'>
     					 ��</td>
			    </tr>
		  </table>
		</td>
	</tr>
	<!--
	<tr>
		<td><span class="style1">* ���� - 1:�Ǹ�����������, 2:������ 3:������ 4:�ٷ�����ó��� 5:ķ���� </span></td>
	</tr>
	-->
	<tr>
		<td><span class="style1">* ����D/C�� �뿩��ݿ����δ� �뿩�� ������/����ȿ���� ������ ��ġ�� �ʽ��ϴ�.</span></td>
	</tr>
  <tr> 
    <td align="right"> 
          <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
          <a href="javascript:save();"><img src="/acar/images/center/button_conf.gif" align="absmiddle" border="0"></a>&nbsp;
          <%}%>
	  <a href="javascript:self.close();"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
    </td>
  </tr>  
</table>
<script language="JavaScript">
<!--	
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	var fm = document.form1;	
	
	if(toInt(parseDigit(fm.s_dc1_amt.value)) > 0 && toFloat(fm.s_dc1_per.value) == 0.0){
		fm.s_dc1_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc1_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
	}
	if(toInt(parseDigit(fm.s_dc2_amt.value)) > 0 && toFloat(fm.s_dc2_per.value) == 0.0){
		fm.s_dc2_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc2_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
	}
	if(toInt(parseDigit(fm.s_dc3_amt.value)) > 0 && toFloat(fm.s_dc3_per.value) == 0.0){
		fm.s_dc3_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc3_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
	}
//-->
</script>
</body>
</html>