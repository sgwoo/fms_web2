<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*"%>
<%@ page import="acar.car_register.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<title>FMS</title>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String[] car_end_dt_arr = request.getParameterValues("car_end_dt");		
	String[] car_mng_id_arr = request.getParameterValues("car_mng_id");
	//���ɸ����� 1�⿬�忡 ���� �Ǹ� ī����VV
	String[] car_end_yn_cnt_arr = request.getParameterValues("car_end_yn_cnt");
	String car_end_yn = "";
	int cnt = car_mng_id_arr.length;
	int flagCnt = 0;
	boolean flag = false;
	boolean flag2 = false;
	boolean flagReal = false;
	String param = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	for(int i=0; i < cnt; i++){
		String car_end_dt = car_end_dt_arr[i];
		String car_mng_id = car_mng_id_arr[i];
		param = param + car_mng_id + ","; 
		car_end_yn = "";
		int car_end_yn_cnt = Integer.parseInt(car_end_yn_cnt_arr[i]);
		
		//���� ���ɸ������� ������Ʈ
		boolean flag1 = crd.updateCarEndDt( car_end_dt, user_id, car_end_yn, car_mng_id );
		
		//�ڵ��� ��ȣ �̷� �űԵ��(���ɸ����� 1�� ����뵵)	
		if(car_end_yn_cnt > 1){
			//�̹� 2���� ��ϵǾ� ������ �� �̻� �������� �ʰ� ó��
			flag2 = true;
		//���ɸ����� ������ 2���̻� ���� ���� ������ ���ؼ��� �ű� ��ϰ��� ����
		}else if(car_end_yn_cnt == 0 || car_end_yn_cnt == 1){
			
			//�� ������ �߿����� �ֽŰ��� ������� ���� ��ϵ��� ���� ������ �ٸ� �ű԰��� ��ϵ��� �ʰ� ó��
			CarHisBean ch_r [] = crd.getCarHisCarEndDt(car_mng_id);
			//int fileCnt = 0;
			cr_bean = crd.getCarRegBean(car_mng_id);
			String car_no = cr_bean.getCar_no();
			String car_ext = cr_bean.getCar_ext();
			
			if(ch_r.length > 0){	//"���ɸ���"�� ������ �űԵ�ϰ��� �Ѱ��̶� �ִ°�� - ������� ��ϵǾ� �ִ��� ��ȸ.
				
    			ch_bean = ch_r[0];	//��ȸ�� �ǵ� �߿��� �ֽ��� �ѰǸ� ���ϸ��.
    			String content_code = "CAR_CHANGE";
				String content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();
				//�� �ǵ��� ������� ��ϵǾ� �ִ��� ��ȸ
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();
				
				if(attach_vt_size > 0){
					//������� ��ϵǾ� ������ �ű� ������� ���� ����
					flag2 = crd.insertCarHisForCarEndDt( car_mng_id, car_end_dt, car_no, user_id, car_ext);
				}else{
					//��ϵǾ� ���������� ����
					flag2 = true;
				}
			}else{	//"���ɸ���"�� ������ �űԵ�ϰ��� �Ѱǵ� ���°��
				flag2 = crd.insertCarHisForCarEndDt( car_mng_id, car_end_dt, car_no, user_id, car_ext);
			}
		}
		if(flag1==true && flag2==true ){
			flagCnt++;
		}
	}
	if(flagCnt==cnt){
		flagReal = true;
	}
%>
	<script type="text/javascript" >
		var flagReal = <%=flagReal%>;
		if(flagReal==true){
			alert("�����Ǿ����ϴ�.");
		}else{
			alert("���� �� �����߻�! \n\n�����ڿ��� �����ϼ���.");
		}
		var param = '<%=param%>';
		//window.opener.document.location.reload();
		window.opener.document.location.href = 'car_end_dt_modify_all.jsp?param='+param+'&modi_chk=1';
		window.close();
	</script>
<%	
%>	
</body>
</html>