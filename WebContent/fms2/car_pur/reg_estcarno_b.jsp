<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<body leftmargin="15">
<%
	//������ȣ �ڵ� ���� ���� ������
	String param 	= request.getParameter("param")==null? "":request.getParameter("param");
	String[] params = param.split(",");
	String errorText = "";
	String alertText = "";
	String udtStText = "";
	String successText = "";
	String type = "";
	String query1 = "";
	String query2 = "";
	int paramCnt = params.length;
	int count = 0;
	int flag1 = 0;
	int flag2 = 0;
	
	//������ȣ �¹ٲٱ� ���� ������
	String car_no1 		= request.getParameter("car_no1")==null?"":request.getParameter("car_no1");
	String car_no2 		= request.getParameter("car_no2")==null?"":request.getParameter("car_no2");
	String rent_l_cd1 	= request.getParameter("rent_l_cd1")==null?"":request.getParameter("rent_l_cd1");
	String rent_l_cd2 	= request.getParameter("rent_l_cd2")==null?"":request.getParameter("rent_l_cd2");
	String car_nm1 		= request.getParameter("car_nm1")==null?"":request.getParameter("car_nm1");
	String car_nm2 		= request.getParameter("car_nm2")==null?"":request.getParameter("car_nm2");
	
	//������ȣ �¹ٲٱ� 
	if(!car_no1.equals("")&&!car_no2.equals("")&&!car_nm1.equals("")&&!car_nm2.equals("")&&!rent_l_cd1.equals("")&&!rent_l_cd2.equals("")){
		
		type = "exchange";
		int s_cnt1 = sc_db.changeCarNoMapping1(car_no1, rent_l_cd2);
		int s_cnt2 = sc_db.changeCarNoMapping2(car_no1, rent_l_cd2, car_nm2);
		int s_cnt3 = sc_db.changeCarNoMapping1(car_no2, rent_l_cd1);
		int s_cnt4 = sc_db.changeCarNoMapping2(car_no2, rent_l_cd1, car_nm1);
		if(s_cnt1==1 && s_cnt3==1 ){	flag1 = 1;	}
		if(s_cnt2==1 && s_cnt4==1 ){	flag2 = 1;	}
		
	}else{	//������ȣ �ڵ� ����
		
		type = "auto";
		//������ �ڵ� ����� �ϳ��� �� ��ȣ�� ������� �ƿ� ������ ���� �ʰ� ī��Ʈ ���� üũ(��û����)
		int cntChk = 0;	// �ش� ������� �� ��ȣ ��
		int incheon_cnt = 0; 
		int ext_cnt1 = 0;	//��õ ī��Ʈ
		int ext_cnt2 = 0;	//�λ� ī��Ʈ
		int ext_cnt3 = 0;	//���� ī��Ʈ
		int ext_cnt4 = 0;	//�뱸 ī��Ʈ
		int ext_cnt5 = 0;	//�� ī��Ʈ
		for(int i=0; i<params.length; i++){
			Vector vt = a_db.getParamForRegCarNo(params[i]);		
			int vt_size = vt.size();
			for(int j = 0 ; j < vt_size ; j++){
				Hashtable ht = (Hashtable)vt.elementAt(j);
				String udt_st_ext = ht.get("UDT_ST_EXT").toString();
				if(udt_st_ext.equals("��õ")) ext_cnt1 ++;
				if(udt_st_ext.equals("�λ�")) ext_cnt2 ++;
				if(udt_st_ext.equals("����")) ext_cnt3 ++;
				if(udt_st_ext.equals("�뱸")) ext_cnt4 ++;
				if(udt_st_ext.equals("��")) ext_cnt5 ++;
			}
		}
		
		Hashtable countList = sc_db.getCarExtCount();
	 	//��� ������ ��ȣ ������ ���ڶ�� �ڵ���� �������� ����
		if(ext_cnt1 > Integer.parseInt((String)countList.get("CNT1"))){		udtStText += "��õ, ";	type = "autoError";		}
		if(ext_cnt2 > Integer.parseInt((String)countList.get("CNT2"))){		udtStText += "�λ�, ";	type = "autoError";		}
		if(ext_cnt3 > Integer.parseInt((String)countList.get("CNT3"))){		udtStText += "����, ";	type = "autoError";		}
		if(ext_cnt4 > Integer.parseInt((String)countList.get("CNT4"))){		udtStText += "�뱸, ";	type = "autoError";		}
		
		if(type.equals("auto")){	//�������� ��ȣ�� ����� ��� - �ڵ���� 
			for(int i=0; i<params.length; i++){
				Vector vt = a_db.getParamForRegCarNo(params[i]);		
				int vt_size = vt.size();
				for(int j = 0 ; j < vt_size ; j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					String m_id = ht.get("RENT_MNG_ID").toString();
					String l_cd = ht.get("RENT_L_CD").toString();
					String car_no = ht.get("CAR_NO").toString();
					String car_nm = ht.get("CAR_NM").toString();
					String udt_st = ht.get("UDT_ST").toString();
					String udt_st_ext = ht.get("UDT_ST_EXT").toString();
					
					if(udt_st.equals("��")){	//�μ����� ���� ���� �ڵ���Ͽ��� ���� ó��
						udtStText += l_cd + "<br>";
						count ++;
					}else{
						
						if(!car_no.equals("")){	// �̹� ������ȣ�� ��ϵǾ� ������ �ڵ������ ��Ű������
							errorText += l_cd+" ("+car_no+")<br>";					
							count ++;
						}else{	//������ȣ�� ��ϵ��� ���� ��츸 �ڵ����� ��� ��Ŵ
							Vector lists = sc_db.getNewCarNumList("","", udt_st_ext, "2","","");
							Hashtable list = (Hashtable)lists.elementAt(0);
							car_no = (String)list.get("CAR_NO");
							
							//��ȣ�� ����� ����
							query1 = " UPDATE car_pur SET est_car_no =replace('"+car_no+"','-','') WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
							query2 = " UPDATE car_scrap SET rent_l_cd ='"+l_cd+"', car_nm = '"+car_nm+"',"+
									 " upd_dt = to_char(sysdate,'YYYYMMDD'), auto_yn = 'Y'"+
									 " WHERE car_no='"+car_no+"'";
							flag1 = a_db.updateEstDt(query1);
							flag2 = sc_db.updateCarScrap(query2);
							
							//ī��Ʈ ó��VV
							if(flag1 == 1 && flag2 == 1){
								successText += l_cd+" --> "+car_no+" ("+udt_st_ext+")<br> ";
								count ++;
							}
						}
					}
				}
			} 
		}
	}
%>
<script language='javascript'>
var errorText = '<%=errorText%>';
var alertText = '<%=alertText%>';
var udtStText = '<%=udtStText%>';
var successText = '<%=successText%>';

<%	if(type.equals("auto")){
		if(paramCnt != count){%>
			alert("��� �� �����߻�! �Ǻ��� ��� �� ������ ����̴� Ȯ�ιٶ��ϴ�.");
			parent.window.close();
			parent.opener.location.reload();
<%		}else{		%>	
			var resultText = "";
			if(errorText!=""){
				resultText += "<div>"+errorText+"</div><br>";
				resultText += "<div>��� ����� �̹� ��ϵ� ������ȣ�� �־� �ڵ���Ͽ��� ���� �Ǿ����ϴ�.</div><br><br>";
			}
			if(alertText!=""){
				resultText += "<div>"+alertText+"</div><br>";
				resultText += "<div>��� ����� ����� ��ȣ�� ��� �ڵ���Ͽ��� ���ܵǾ����ϴ�.</div>";
				resultText += "<div>����������\�ű��ڵ�����ȣ���� ���� ��ȣ�� �������ּ���.</div><br><br>";
			}
			if(udtStText!=""){
				resultText += "<div>"+udtStText+"</div><br>";
				resultText += "<div>��� ����� �μ����� <��> �̾ �ڵ���Ͽ��� ���� �Ǿ����ϴ�.</div><br><br>";
			}
			if(successText!=""){
				resultText += "<div>"+successText+"</div><br>";
				resultText += "<div>��� ����� ���� ó���Ǿ����ϴ�.</div><br>";
			}
			alert("�ڵ������ ���� �Ϸ�Ǿ����ϴ�.");
			$(document).ready(function(){
				$("#result_div").html(resultText);
			})
			//parent.window.close();
			parent.opener.location.reload();
<%		}
	}else if(type.equals("exchange")){
		if(flag1 == 0 || flag2 == 0){	%>
			alert("ó������ �ʾҽ��ϴ�.");
			location='about:blank';	
<%		}else{	%>
			alert("ó���Ǿ����ϴ�.");
			parent.window.close();
			parent.opener.location.reload();
<%		}
	}else if(type.equals("autoError")){	%>	
		alert(udtStText + "\n\n���� ������ ��ϰ��ɹ�ȣ�� ������ ���Ǻ��� ���ڶ��ϴ�.\n\n��ȣ�� ��� �� �ٽ� �õ����ּ���.");
		parent.window.close();
<%	}	%>
</script>
	<div id="result_div" style="margin-top: 30px; margin-left: 30px;"></div>
	<div style="margin-left: 30px;" align="center">
		<input type="button" class="button" value="�ݱ�" onclick="window.close();">
	</div>
</body>
</html>
