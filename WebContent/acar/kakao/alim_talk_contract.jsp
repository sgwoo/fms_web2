<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="acar.kakao.*, acar.cont.*, acar.fee.*, acar.client.*, acar.car_mst.*, acar.car_register.*" %>
<%@ page import="acar.cont.AddContDatabase" %>
<%@ page import="acar.cont.CarMgrBean" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="at_db" scope="page" class="acar.kakao.AlimTemplateDatabase"/>
<jsp:useBean id="cr_bean" scope="page" class="acar.car_register.CarRegBean"/>

<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
    // �Ķ����
    String rentMngId = request.getParameter("mng_id")==null? "":request.getParameter("mng_id");
    String rentLCode = request.getParameter("l_cd")==null? "":request.getParameter("l_cd");
    String carCompId = request.getParameter("car_comp_id")==null? "":request.getParameter("car_comp_id");
    String rent_st = request.getParameter("rent_st")==null? "":request.getParameter("rent_st");
    String dept_id = request.getParameter("dept_id") == null ? "" : request.getParameter("dept_id");
    
    AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();	
    CarRegDatabase crd = CarRegDatabase.getInstance();
    AlimTalkLogDatabase atl_db = AlimTalkLogDatabase.getInstance();
    
  	//���⺻����
  	ContBaseBean base = a_db.getCont(rentMngId, rentLCode);
  	
  	//������
  	ClientBean client = al_db.getNewClient(base.getClient_id());
  	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rentMngId, rentLCode);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�������
	ContPurBean pur = a_db.getContPur(rentMngId, rentLCode);
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(cr_bean.getCar_num().equals("")){
		pur.getCar_num();
	}
	
  	//�뿩���� ī����
  	int fee_count	= af_db.getFeeCount(rentLCode);
  	if (rent_st.equals("")) {
  		rent_st = String.valueOf(fee_count);
  	}
  	//�����뿩������ �뿩Ƚ�� �ִ밪
  	int max_fee_tm 	= a_db.getMax_fee_tm(rentMngId, rentLCode, rent_st);

    // īī�� ���ø� �ڵ� ����Ʈ
    // ���⿡ �߰��ϸ� �ڵ����� ���̺� �� (���ø� �������� �ڵ常 ���� �մϴ�.)
    // ��) ���� : Y, ��� : Y
    /* String[] templateCodes = {
		"acar0231",		//����� ����⵿ �ȳ� new
		"acar0233",		//�Ƹ���ī ���ó�� �ȳ�
		"acar0208",		//�����˻� �ȳ�
		"acar0194",		//1ȸ�� �̳� ��ü �ȳ�
		"acar0211",		//�뿩���� �ȳ�
		"acar0193",		//������� �� �����ݳ��뺸
		"acar0155",		//�����༭ ���Ϲ߼� �˸�
		"acar0255",		//����Ʈ ���Ȯ�� �ȳ�
		"acar0170",    	//����Ʈ ������� �ȳ�
		"acar0198",		//����� ���� �� ���� �� �˸��� ����
		"acar0164",		//��縵ũ ���� ���Թ�� �ȳ�
		"acar0221"		//FMS(fleet management system) �̿��� �ȳ�
    }; */
    
    String[] templateCodes = null;
    //���¾�ü�� ������ Ʋ������� �ش� ������ ��� �Ұ�
    if(dept_id.equals("1000")){		// ������Ʈ fms

	    if (carCompId.equals("0001")) {
	    	
	    	String temp_car_nm = cm_bean.getCar_nm();
	    	temp_car_nm.replace(" ", "");
	    	
	    	if ((temp_car_nm.contains("���׽ý�") == false) && !client.getClient_st().equals("1") && base.getCar_gu().equals("1")) {
	    		templateCodes = new String[] {
		   			"acar0211",		// �뿩���� �ȳ�
		   			"acar0221",		// FMS(fleet management system) �̿��� �ȳ�
		   			"acar0231",		// ���� �� ����⵿ �ȳ� new
		   			"acar0233",		// �Ƹ���ī ���ó�� �ȳ�
		   			"acar0164",		// ��縵ũ ���� ���Թ�� �ȳ�
		   			"acar0230",		// ������� �ȳ� �˸���
		   			"acar0268",		// ������ ���ξȳ���
		   			
		    	};
	    	} else {
	    		if (base.getCar_gu().equals("1")) {//����
			    	templateCodes = new String[] {
			   			"acar0211",		// �뿩���� �ȳ�
			   			"acar0221",		// FMS(fleet management system) �̿��� �ȳ�
		   				"acar0231",		// ����� ����⵿ �ȳ� new
		   				"acar0233",		// �Ƹ���ī ���ó�� �ȳ�
			   			"acar0164",		// ��縵ũ ���� ���Թ�� �ȳ�
			   			"acar0268",		// ������ ���ξȳ���
		    		};
	    		}else{
			    	templateCodes = new String[] {//�縮��
				   			"acar0211",		// �뿩���� �ȳ�
				   			"acar0221",		// FMS(fleet management system) �̿��� �ȳ�
			   				"acar0231",		// ����� ����⵿ �ȳ� new
			   				"acar0233",		// �Ƹ���ī ���ó�� �ȳ�
				   			"acar0164",		// ��縵ũ ���� ���Թ�� �ȳ�
				   			"acar0277",		// ������ ���ξȳ���(�縮��)
			    		};	    			
	    		}
		    	
	    	}
		} else {
			if (base.getCar_gu().equals("1")) {//����
		    	templateCodes = new String[] {
		   			"acar0211",		// �뿩���� �ȳ�
	   				"acar0221",		// FMS(fleet management system) �̿��� �ȳ�
	   				"acar0231",		// ����� ����⵿ �ȳ� new
	   				"acar0233",		// �Ƹ���ī ���ó�� �ȳ�
		   			"acar0268",		// ������ ���ξȳ���
				};
			}else{
		    	templateCodes = new String[] {
			   			"acar0211",		// �뿩���� �ȳ�
		   				"acar0221",		// FMS(fleet management system) �̿��� �ȳ�
		   				"acar0231",		// ����� ����⵿ �ȳ� new
		   				"acar0233",		// �Ƹ���ī ���ó�� �ȳ�
			   			"acar0277",		// ������ ���ξȳ���(�縮��)
					};				
			}
		}
     	
    } else {		// ���� fms
    	
	    if (carCompId.equals("0001")) {
	    	
	    	String temp_car_nm = cm_bean.getCar_nm();
	    	temp_car_nm.replace(" ", "");
	    	
	    	if ((temp_car_nm.contains("���׽ý�") == false) && !client.getClient_st().equals("1") && base.getCar_gu().equals("1")) {
	    		
		    	templateCodes = new String[] {
		   			"acar0231",		//����� ����⵿ �ȳ� new
		   			"acar0233",		//�Ƹ���ī ���ó�� �ȳ�
		   			"acar0208",		//�����˻� �ȳ�
		   			"acar0194",		//1ȸ�� �̳� ��ü �ȳ�
		   			"acar0211",		//�뿩���� �ȳ�
		   			"acar0193",		//������� �� �����ݳ��뺸
		   			"acar0155",		//�����༭ ���Ϲ߼� �˸�
		   			"acar0255",		//����Ʈ ���Ȯ�� �ȳ�
		   			"acar0170",    	//����Ʈ ������� �ȳ�
		   			"acar0198",		//����� ���� �� ���� �� �˸��� ����
		   			"acar0221",		//FMS(fleet management system) �̿��� �ȳ�
		   			"acar0164",		//��縵ũ ���� ���Թ�� �ȳ�
		   			"acar0230",		//������� �ȳ� �˸���
		   			"acar0268",		// ������ ���ξȳ���
		    	};
		    	
	    	} else {
	    		if (base.getCar_gu().equals("1")) {//����	    		
			    	templateCodes = new String[] {
			   			"acar0231",		//����� ����⵿ �ȳ� new
			   			"acar0233",		//�Ƹ���ī ���ó�� �ȳ�
		   				"acar0208",		//�����˻� �ȳ�
		   				"acar0194",		//1ȸ�� �̳� ��ü �ȳ�
			   			"acar0211",		//�뿩���� �ȳ�
			   			"acar0193",		//������� �� �����ݳ��뺸
			   			"acar0155",		//�����༭ ���Ϲ߼� �˸�
		   				"acar0255",		//����Ʈ ���Ȯ�� �ȳ�
		   				"acar0170",    	//����Ʈ ������� �ȳ�
			   			"acar0198",		//����� ���� �� ���� �� �˸��� ����
			   			"acar0221",		//FMS(fleet management system) �̿��� �ȳ�
			   			"acar0164",		//��縵ũ ���� ���Թ�� �ȳ�
		   				"acar0268",		// ������ ���ξȳ���
			    	};
	    		}else{
			    	templateCodes = new String[] {
				   			"acar0231",		//����� ����⵿ �ȳ� new
				   			"acar0233",		//�Ƹ���ī ���ó�� �ȳ�
			   				"acar0208",		//�����˻� �ȳ�
			   				"acar0194",		//1ȸ�� �̳� ��ü �ȳ�
				   			"acar0211",		//�뿩���� �ȳ�
				   			"acar0193",		//������� �� �����ݳ��뺸
				   			"acar0155",		//�����༭ ���Ϲ߼� �˸�
			   				"acar0255",		//����Ʈ ���Ȯ�� �ȳ�
			   				"acar0170",    	//����Ʈ ������� �ȳ�
				   			"acar0198",		//����� ���� �� ���� �� �˸��� ����
				   			"acar0221",		//FMS(fleet management system) �̿��� �ȳ�
				   			"acar0164",		//��縵ũ ���� ���Թ�� �ȳ�
			   				"acar0277",		// ������ ���ξȳ���(�縮��)
				    	};	    			
	    		}
		    	
	    	}
	    	
	    } else {
	    	if (base.getCar_gu().equals("1")) {//����	    	
		    	templateCodes = new String[] {
		   			"acar0231",		//����� ����⵿ �ȳ� new
	   				"acar0233",		//�Ƹ���ī ���ó�� �ȳ�
	   				"acar0208",		//�����˻� �ȳ�
		   			"acar0194",		//1ȸ�� �̳� ��ü �ȳ�
		   			"acar0211",		//�뿩���� �ȳ�
	   				"acar0193",		//������� �� �����ݳ��뺸
	   				"acar0155",		//�����༭ ���Ϲ߼� �˸�
		   			"acar0255",		//����Ʈ ���Ȯ�� �ȳ�
		   			"acar0170",    	//����Ʈ ������� �ȳ�
	   				"acar0198",		//����� ���� �� ���� �� �˸��� ����
	   				"acar0221",		//FMS(fleet management system) �̿��� �ȳ�
		   			"acar0268",		//������ ���ξȳ���
	    		};
	    	}else{
		    	templateCodes = new String[] {
			   			"acar0231",		//����� ����⵿ �ȳ� new
		   				"acar0233",		//�Ƹ���ī ���ó�� �ȳ�
		   				"acar0208",		//�����˻� �ȳ�
			   			"acar0194",		//1ȸ�� �̳� ��ü �ȳ�
			   			"acar0211",		//�뿩���� �ȳ�
		   				"acar0193",		//������� �� �����ݳ��뺸
		   				"acar0155",		//�����༭ ���Ϲ߼� �˸�
			   			"acar0255",		//����Ʈ ���Ȯ�� �ȳ�
			   			"acar0170",    	//����Ʈ ������� �ȳ�
		   				"acar0198",		//����� ���� �� ���� �� �˸��� ����
		   				"acar0221",		//FMS(fleet management system) �̿��� �ȳ�
			   			"acar0277",		// ������ ���ξȳ���(�縮��)
		    		};	    		
	    	}
	    }
    }
             
    // DB���� ���ø� ����Ʈ ������ - log�� show_list�� no���� display 
	// AlimTemplateDatabase at_db = AlimTemplateDatabase.getInstance();
  	// List<AlimTemplateBean> allTemplateList = at_db.selectTemplateList("0", false);
  	// log �� - 20171212
	List<AlimTemplateBean> allTemplateList = at_db.selectTemplateLogList("0", "0", false); 
     
    // ������ ���ø� ����Ʈ�� ���
    ArrayList<AlimTemplateBean> templateList = new ArrayList<AlimTemplateBean>();

    for (int i = 0; i < allTemplateList.size(); i++) {
        AlimTemplateBean template = allTemplateList.get(i);

        for (int j = 0; j < templateCodes.length; j++) {
            if (template.getCode().equals(templateCodes[j])) {
                templateList.add(template);
            }
        }
    }

    // �˸��� �α� ������ (����ȣ�� �˻�)  - log�� show_list�� no���� display 
	List<AlimTalkLogBean> logList = atl_db.selectByContract(rentLCode);

    // ���ø��� �ֱ� �α� �Ѱ��� ����
    HashMap<String, AlimTalkLogBean> recentLog = new HashMap<String, AlimTalkLogBean>();
    for (int i = 0; i < logList.size(); i++) {
        AlimTalkLogBean log = logList.get(i);
        for (int j = 0; j < templateCodes.length; j++) {

            // �ʿ� �Ѱ����� �����Ѵ�
            if (log.getTemplate_code() != null && log.getTemplate_code().equals(templateCodes[j])) {
               if (recentLog.containsKey(templateCodes[j]) == false) {
                   recentLog.put(templateCodes[j], log);
               }
            }
        }
    }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>

<style type="text/css">
    .table-style-1 {
        font-family:����, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
        color: #515150;
        font-weight: bold;
    }
    .table-back-1 {
        background-color: #B0BAEC
    }
    .table-body-1 {
        text-align: center;
        height: 26px;
    }
    .table-body-2 {
        text-align: left;
        padding-left: 10px;
        font-size: 10pt;
    }
    .font-1 {
        font-family:����, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
        font-weight: bold;
    }
    .font-2 {
        font-family:����, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
    }
</style>

<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">

	var rentMngId = '<%= rentMngId %>';
	var rentLCode = '<%= rentLCode %>';
	var carCompId = '<%= carCompId %>';
	var rentSt = '<%= rent_st %>';
	var max_fee_tm = '<%= max_fee_tm %>';

	$(document).ready(function(){
	
	});

	// �˸��� �߼� Ŭ�� - ��ġ�� ó���Ǵ� ��� show_list�� 'N'�ΰ�쵵 ����.
	function onClickSend(category_1, templateCode) {
		
		if (templateCode == "acar0221") {
			if (max_fee_tm == "" || max_fee_tm == "0") {
				alert("������ �������� �����ϴ�. Ȯ���Ͻʽÿ�.");
				return;
			}
		}
		
		// alert("SEND (mng_id: " + rentMsgId + " l_cd: " + rentLCode + " template_code: " + templateCode + ")");
		var url = '/acar/kakao/alim_talk.jsp?s_type=log&cate=1&cate1=' + category_1 + '&t_cd=' + templateCode + '&mng_id=' + rentMngId + '&l_cd=' + rentLCode + '&rent_st=' + rentSt;
		window.open(url, 'ALIM_TALK', "left=50, top=50, width=850, height=850, scrollbars=yes");
	}
	
	// �̷� ���� Ŭ��
	function onClickHistory(templateCode) {
		// alert("HISTORY (template_code: " + templateCode + ")");
		var url = '/acar/kakao/alim_talk_log.jsp?s_type=log&t_cd=' + templateCode + '&mng_id=' + rentMngId + '&l_cd=' + rentLCode;
		window.open(url, 'ALIM_TALK_LOG', "left=50, top=50, width=1250, height=850, scrollbars=yes");
	}

</script>
</head>

<body leftmargin="15">

<%-- ��� --%>
<div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan=10>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�˸��� > <span class=style5>�˸���߼۰���</span></span></td>
                        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr><td class=h></td></tr>
    </table>
</div>

<%-- �˸��� �߼� --%>
<div>
    <br>
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">�˸��� �߼�</div>
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="700" style="margin-top: 8px">
        <tr><td class=line2 colspan=2></td></tr>
        <tr>
            <td rowspan="2" class="title" width=5%>����</td>
            <td rowspan="2" class="title" width=35%>�ȳ���</td>
            <td rowspan="2" class="title" width=10%>����</td>
            <td colspan="3" class="title" width=50%>�ֱٹ߼��̷�</td>
        </tr>
        <tr>
            <td class="title" width=15%>�Ͻ�</td>
            <td class="title" width=25%>�߼���</td>
            <td class="title" width=10%>�̷º���</td>
        </tr>
        <% for (int i = 0; i < templateList.size(); i++) {
            AlimTemplateBean template = templateList.get(i);
        %>
            <tr class="table-body-1">
                <td><%= i + 1 %></td>
                <td class="table-body-2"><%= template.getName() %></td>
                <td><button onclick="onClickSend('<%= template.getCategory_1() %>','<%= template.getCode() %>')">����</button></td>

                <%  if (recentLog.containsKey(template.getCode())) {
                        AlimTalkLogBean log = recentLog.get(template.getCode());
                %>
                        <td><%=log.getDate_client_req_str()%></td>
                        <% if (log.getUserNm() == null || log.getUserNm().equals("")) { %>
                            <td><%=log.getCallback()%></td>
                        <% } else { %>
                            <td><%=log.getUserNm()%></td>
                        <% } %>
                        <td><button onclick="onClickHistory('<%= template.getCode() %>')">����</button></td>
                <%  } else { %>
                        <td>-</td><td>-</td><td>-</td>
                <%  } %>
            </tr>
        <% } %>

    </table>
</div>

</body>
</html>
