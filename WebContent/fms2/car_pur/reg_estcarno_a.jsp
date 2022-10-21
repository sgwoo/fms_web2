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

<body leftmargin="15">
<%
	//���������ȣ ���� ó�� ������
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String est_car_no 	= request.getParameter("est_car_no")==null?"":request.getParameter("est_car_no");
	String est_car_num	= request.getParameter("est_car_num")==null?"":request.getParameter("est_car_num");
	String car_nm		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	//String process 		= request.getParameter("process")==null?"":request.getParameter("process");
	String tmp_drv_no = request.getParameter("tmp_drv_no")==null?"":request.getParameter("tmp_drv_no");		// �ӽ�������ȣ		2017.12.07
		
	String query1 = "";
	String query2 = "";
	String query3 = "";
	int flag1 = 0;
	int flag2 = 0;
	boolean flag3 = true;
	
	//car_pur ���̺� ������Ʈ(���� �ҽ�)
	query1 = " UPDATE car_pur SET est_car_no =replace('"+est_car_no+"','-',''), car_num =replace('"+est_car_num+"','-','')   WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
	query2 = " UPDATE car_scrap SET rent_l_cd ='"+l_cd+"', car_nm = '"+car_nm+"',"+
			 " upd_dt = to_char(sysdate,'YYYYMMDD'), auto_yn = 'N'"+
			 " WHERE car_no='"+est_car_no+"'";
	query3 = " UPDATE car_scrap SET rent_l_cd = null, car_nm = null,"+
			 " upd_dt = to_char(sysdate,'YYYYMMDD'), auto_yn = 'N'"+
			 " WHERE rent_l_cd='"+l_cd+"'";
	
	if(!est_car_no.equals("")){
		//����, �ش� ������ȣ�� ���ε� ����� �̹� �ִ��� üũ
		int resultCnt = sc_db.getCarNoMappingYn2(est_car_no, l_cd);		// �ڱ� �ڽ��� ��� ���� ��� �߰� 2017.12.12
							
		if(resultCnt != 0){		//�ش��ȣ�� ���ε� ����� �̹� ������ �ΰ��� ���������� �ٲٱ�
			String rent_l_cd2 = sc_db.getCarNoMappingInfo(est_car_no);
			Vector lists1 = sc_db.getNewCarNumList("","","","1",l_cd,"");
			Vector lists2 = sc_db.getNewCarNumList("","","","1",rent_l_cd2,"");
			
			if(lists1 != null && lists2 != null && !lists1.isEmpty() && !lists2.isEmpty()){
				Hashtable list1 = (Hashtable)lists1.elementAt(0);
				Hashtable list2 = (Hashtable)lists2.elementAt(0);
				String car_no1 = (String)list1.get("CAR_NO");
				String car_no2 = (String)list2.get("CAR_NO");
				String car_nm1 = (String)list1.get("CAR_NM");
				String car_nm2 = (String)list2.get("CAR_NM");
%>
				<script language='javascript'>
					var car_no1 = '<%=car_no1%>';		//���� 
					var car_no2 = '<%=car_no2%>';		//����
					var car_nm1 = '<%=car_nm1%>';		//����
					var car_nm2 = '<%=car_nm2%>';		//����
					var rent_l_cd1 = '<%=l_cd%>';		//����
					var rent_l_cd2 = '<%=rent_l_cd2%>';	//����		
					var alertText = car_no2 +"�ش� �ڵ�����ȣ�� ��ϵ� ������ �̹� �����մϴ�.\n\n"+
					                "1 : "+rent_l_cd1+" : "+car_no1+"  --> "+rent_l_cd1+" : "+car_no2+"\n\n"+
					                "2 : "+rent_l_cd2+" : "+car_no2+"  --> "+rent_l_cd2+" : "+car_no1+"\n\n"+
					                "�� ������ ������ȣ�� ���� �ٲٽðڽ��ϱ�?";
					if(!confirm(alertText)){
						alert("��ҵǾ����ϴ�");
						location='about:blank';	
					}else{
						location.href='/fms2/car_pur/reg_estcarno_b.jsp?car_no1='+car_no1+'&car_no2='+car_no2+'&rent_l_cd1='+rent_l_cd1+'&rent_l_cd2='+rent_l_cd2+'&car_nm1='+car_nm1+'&car_nm2='+car_nm2;
					}
			</script>
<%				}else{ %>
			<script type="text/javascript">
					alert("������ ���� ��ȣ�� �� ��ȣ ���\n\n�ű��ڵ�����ȣ����/���������� �� ��ϵ� ��ȣ�̾�� �մϴ�.\n\n��Ȯ��(��ȣ���)�� �ٽ� �õ����ּ���.");
					location='about:blank';
			</script>		
<%				}
		}else{	//���ε� ������ ������
			String rent_l_cd2 = sc_db.getCarNoMappingInfo(est_car_no);	//������ ���εȰ��� �ְ� ���ξȵȹ�ȣ�� ���������� �ٲ�ߵǴ� ��츦 üũ
			if(rent_l_cd2==null || rent_l_cd2.equals("")){//���εȰ��� �ִµ� �űԹ�ȣ(���ξȵ�)�� ���� ���ε� ���� ����ȣ�� ���� ��Ī��ų ���
				//���� ������ ������� ������Ʈ
				flag2 = sc_db.updateCarScrap(query3);	//1
				//���ο� ��ȣ�� ����
				int s_flag1 = a_db.updateEstDt(query1);	
				int s_flag2 = sc_db.updateCarScrap(query2);	//2	(1,2 ���� �ٲٸ� �ȵ�!!)
				if(s_flag1==1 && s_flag2==1){ flag1 = 1; }
			}else{	//���ε� ���� ���� ��࿡ ����ȣ�� �����ϴ� ���
				flag1 = a_db.updateEstDt(query1);
				flag2 = sc_db.updateCarScrap(query2);
			}
		}
	}else{ 	// ���������ȣ�� ���϶��� null�� �ٽ� ������Ʈ
		flag1 = a_db.updateEstDt(query1);
		flag2 = sc_db.updateCarScrap(query3);
	}
	
	// �ӽ�������ȣ update		2017.12.07
	if(m_id.length() > 0 && l_cd.length() > 0){
		flag3 = a_db.updateTmpDrvNo(tmp_drv_no, m_id, l_cd);
	}
	
%>
<script language='javascript'>
<%	if(flag3 == false){%>
		alert("�ӽ�������ȣ ���忡 �����Ͽ����ϴ�");
		parent.window.close();
		parent.opener.location.reload();
<%	}else if(flag1 == 0 && flag2 == 0){%>// or ������ and�� ����  2017.12.12
		alert("ó������ �ʾҽ��ϴ�");
		//location='about:blank';
		parent.window.close();
		parent.opener.location.reload();
<%	}else{		%>		
		alert("ó���Ǿ����ϴ�");
		<%if(mode.equals("board")){%>	
			parent.window.close();
			parent.opener.location.reload();
		<%}%>
<%	}			%>
</script>