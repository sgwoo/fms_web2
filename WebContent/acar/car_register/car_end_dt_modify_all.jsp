<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.car_register.*, acar.cus_reg.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String param 	= request.getParameter("param")==null?"":request.getParameter("param");
	String modi_chk	= request.getParameter("modi_chk")==null?"0":request.getParameter("modi_chk");
	String[] params = param.split(",");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript">
$(document).ready(function(){
	//���ɸ����� 1ȸ ����� �����˾������� ���̻� ���� �Ұ� ó��
	var modi_chk = '<%=modi_chk%>';
	if(modi_chk=="1"){
		$("#btn_carEndDt").css("display","none");
		$("#alert1").css("display","block");
	}
});
// ���ɸ����� ���� �� ������ȣ���� �̷� �űԻ���  - �ϰ���ư
function saveAllCarEndDt(){
	var fm = document.form1;
	//var url = document.location.href;
	if(confirm('���� ���� �״�� �ϰ� ���� �� ��� �˴ϴ�.\n\n�����Ͻðڽ��ϱ�?')){
		window.open('about:blank', "saveAllCarEndDt", "width=500, height=200");
		fm.target = "saveAllCarEndDt";		
		fm.action = "car_end_dt_modify_all_a.jsp";
		fm.submit();
	}
}

//2ȸ ���忩�� ����  - �ϰ���ư
function saveAllCarEndYn(){
	var fm = document.form1;
	if(confirm('"<���ɸ����� ����>���� 2�� ���� �� ������� ����� ����"�� 2ȸ���� ���θ� ���� �Ͻðڽ��ϱ�?')){
		window.open('about:blank', "saveAllCarEndYn", "width=500, height=200");
		fm.target = "saveAllCarEndYn";		
		fm.action = "car_end_dt_modify_all_b.jsp";
		fm.submit();
	}
}

//��ĵ���(�� �Ǵ�)
function scan_reg(car_mng_id, cha_seq, car_no){
	window.open("reg_scan.jsp?car_mng_id="+car_mng_id+"&cha_seq="+cha_seq+"&subject="+car_no, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}	

//�������� �ϰ����� ��ư  - �ϰ���ư
function modifyAllChaDt(){
	var length = '<%=params.length%>';
	for(var i=0; i<length; i++){
		if($("#cha_dt_"+i).val()!=""){
			//var data = $("#data_"+i).val() + $("#cha_dt_"+i).val();
			var data = $("#data_"+i).val() + $("#cha_dt_all").val();
			$("#data_"+i).val(data);
		}
	}
	var fm = document.form1;
	if(confirm('"���ɸ����� 1�� ����"������ ������ �ڵ�����ȣ�̷��� �����ϸ�,\n\n���� ������ ��ȣ�̷��� �������ڸ� ���� ���� �״�� �����մϴ�.\n\n�������ڸ� �ش� ��¥�� �ϰ� ���� �Ͻðڽ��ϱ�?')){
		window.open('about:blank', "modifyAllChaDt", "width=500, height=200");
		fm.target = "saveAllChaDt";		
		fm.action = "car_end_dt_modify_all_c.jsp";
		fm.submit();
	}
}

</script>
</head>
<body>
	<form name='form1' method='post'>
		<table width=1080 border=0 cellpadding=0 cellspacing=0>
		    <tr>
		        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
		        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>���ɸ����� �ϰ�����</span></span></td>
		        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
		    </tr>
		    <tr height="10px;"></tr>
		</table>
		<div style="font-size: 13px; padding-bottom: 10px; margin-top:20px; float: left;">
			<div style="margin-bottom: 10px;">�� ���ɸ����� �����, ���� ���ɸ����� ���� 1���� �ڵ� ����, ����ȣ�̷µ�ϰ��� �ű� ����(2�Ǳ���), ����� ��Ϲ�ư�� �����˴ϴ�.</div>
			<div style="margin-bottom: 10px;">�� ������ ��Ϲ�ư�� �̿��� ������� ����մϴ�.<br> &nbsp;&nbsp;&nbsp;&nbsp;��, �ϰ�â������ ����� �� ���� �ֽŰ� 1�Ǹ� ���������ϹǷ� ���� ������� ������� ����, ����Ϸ��� �������� �� ���������� �ؾ��մϴ�.</div>
			<div style="margin-bottom: 10px;">�� ����� ��� �� 2ȸ���� ���� �����, ���� ��ϵ� "���������Ͽ���"�� 2���� ������� üũ �� �ڵ� �������� ó���մϴ�. <br> &nbsp;&nbsp;&nbsp;&nbsp;(���� ������ �ֱ� ������� ������� ����߾ 2ȸ���忩�ΰ� ���ŵ��� ���� �� ������, �ش� ������ ���������� Ȯ�����ּ���.)</div>
			<div>�� ��ưŬ�� �� ���� ���� �Ǿ��ٴ� �޽��� �Ŀ��� ȭ���� ���ΰ�ħ ���� �ʴ� ���, ���ΰ�ħ�� �����ּ���. </div>
			<div id="alert1" style="color: red; display:none;">�� �̹� ���ɸ������� 1ȸ �����Ͽ����ϴ�. �ߺ� Ŭ�������� ���� ���� ������������ ���̻� ���ɸ����� ������ �����մϴ�.</div>
			<br>
		</div>	
		<div align="right" style="position: relative; margin-right: 35px; margin-bottom: 20px;">
			<input type="button" class="button" id="btn_carEndDt" value="���ɸ����� ����" onclick="javascript:saveAllCarEndDt()" style="margin-bottom: 15px; width: 130px;"><br>
			<input type="button" class="button" value="2ȸ���忩�� ����" onclick="javascript:saveAllCarEndYn()" style="margin-bottom: 15px; width: 130px;"><br>
			<input type="text" id="cha_dt_all" name="cha_dt_all" style="margin-bottom: 2px; width: 130px;" placeholder="ex) 2018-01-23"><br>
			<input type="button" class="button" value="�������� �ϰ�����" onclick="javascript:modifyAllChaDt()" style="margin-bottom: 15px; width: 130px;"><br> 
			<input type="button" class="button" value="���ΰ�ħ" onclick="javascript:window.location.reload();" style="width: 130px;">
		</div>
	
		<table border=0 cellspacing=0 cellpadding=0 width="100%">
			<tr>
				<td>
					<table border=0 cellspacing=0 cellpadding=0 width="100%">
						<tr>
							<td class=line2></td>
						</tr>
						<tr>
							<td class=line>
								<table border=0 cellspacing=1 width=100%>
									<tr>
										<td width=3% class=title>����</td>
										<td width=15% class=title>�������ĵ</td>
										<td width=8% class=title>������ȣ</td>
										<td width=16% class=title>����</td>
										<td width=17% class=title>���ɸ�����</td>
										<td width=8% class=title>2ȸ���忩��</td>
										<td width=8% class=title>������ȣ</td>									
										<td width=8% class=title>��������</td>
									</tr>
								<%
								for(int i=0; i<params.length; i++){
									Vector vt = crd.getModifyCarEndDtList(params[i]);									
									int vt_size = vt.size();
									Hashtable ht = (Hashtable)vt.elementAt(0);
									String car_end_dt = (String)ht.get("CAR_END_DT");
									int year = Integer.parseInt(car_end_dt.substring(1,4));
									String new_car_end_dt = car_end_dt.substring(0,2) + Integer.toString(year+1) + car_end_dt.substring(4);
									
									CarHisBean ch_r [] = crd.getCarHisCarEndDt(params[i]);
								%>
									<tr>
										<td width=3% align="center">
											<%=i+1%>
											<input type="hidden" name="car_mng_id" value="<%=params[i]%>">
											<input type="hidden" name="car_end_yn_cnt" value="<%=ch_r.length%>">
										</td> <!-- ���� -->
										<%	
									if(ch_r.length > 0){
						        		for(int j=0; j<1; j++){
						        			ch_bean = ch_r[j];
						        			String content_code = "CAR_CHANGE";
						    				String content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();
						    				
						    				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
						    				int attach_vt_size = attach_vt.size(); %>
										<%  if(attach_vt_size > 0){%>
								    	<%		for (int k = 0 ; k < attach_vt_size ; k++){
				    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(k);    								
					    						%>
													<td width=15% align="center">
					    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>    							
					    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
													</td><!-- ����� ��ĵ -->
										<%		}%>
				    						<%}else{%>
					    						<td width=15% align="center">
					    							<a href="javascript:scan_reg('<%=ch_bean.getCar_mng_id()%>','<%=ch_bean.getCha_seq()%>','<%=ht.get("CAR_NO")%>')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a>
					    						</td>
				    						<%}%>
								<%		}%>
								<%	}else{ %>
										<td width=15% align="center">
			    							<%-- <a href="javascript:scan_reg('<%=ch_bean.getCar_mng_id()%>','<%=ch_bean.getCha_seq()%>')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a> --%>
			    							������ ��Ϲ�ư ����
			    						</td>
								<%	}%>
										<td width=8% align="center"><%=ht.get("CAR_NO")%></a></td><!-- ������ȣ -->
										<td width=16% align="center"><span
											title="<%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%>"><%= Util.subData(ht.get("CAR_NM")+" "+ht.get("CAR_NAME"),25) %></span></td><!-- ���� -->										
										<td width=17% align="center">
											<div style="float: left; margin-top: 3px;">&nbsp; <%=ht.get("CAR_END_DT")%> &nbsp;��</div>  
											<div style="position: relative;"><input type="text" name="car_end_dt" value="<%=new_car_end_dt%>" size="10" style="text-align: center;"></div>
										</td><!-- ���ɸ����� -->
										<td width=8% align="right" style="padding-right: 10px;"><%=ht.get("CAR_END_YN")%> ( <%=ch_r.length%>ȸ )</td><!-- �������忩�� -->
										<td width=8% align="center"><%=ht.get("CAR_DOC_NO")%></td><!-- ������ȣ -->
						
									<td align="center">
								<% 	if(ht.get("CHA_DT")!=null && !ht.get("CHA_DT").equals("")){%>	
										<%=ht.get("CHA_DT")%>
										<input type="hidden" id="cha_dt_<%=i%>" value="<%=ht.get("CHA_DT")%>">
								<% 	}else{%>
										<input type="hidden" id="cha_dt_<%=i%>" value=""/>
								<% 	}%>		
										<input type="hidden" name="data" id="data_<%=i%>" value="<%=params[i]%>//<%=ht.get("CHA_SEQ")%>//">
									</td>
								</tr>
							<%	}%>
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