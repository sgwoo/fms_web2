/**
 * ������������-����
 */
package acar.estimate_mng;
import java.util.*;

public class EstiCommVarBean {

	//Table : ESTI_COMM_VAR
    private String a_a;			//�뿩����
    private String seq;			//�Ϸù�ȣ
    private float  a_f;			//����������
    private int    a_g_1;		//10��������Һα�-36����
    private int    a_g_2;		//10��������Һα�-24����
    private int    a_g_3;		//10��������Һα�-18����
    private int    a_g_4;		//10��������Һα�-12����
    private int    a_g_5;		//10��������Һα�-42����
	private int    a_g_6;		//10��������Һα�-30����	//2005.3.23.
	private int    a_g_7;		//10��������Һα�-48����	//2005.3.23.
	private String a_j;			//����������
    private float  o_8_1;		//ä��������-����
    private float  o_8_2;		//ä��������-���
    private int    o_9_1;		//��Ϻδ���-����
    private int    o_9_2;		//��Ϻδ���-���
	private float  o_10;		//���ް���������
    private float  o_12;		//Ư�Ҽ�ȯ����
    private String o_e;			//������������ ��������
	private int    oa_b;		//�빰,�ڼպ��� 1�ﰡ�Խ� �뿩�� �λ��
	private float  oa_c;		//��21���������� ���Խ� �뿩�� �λ�(�������)
    private int    g_1;			//����������
    private float  g_3;			//���պ����� ������
    private float  g_5;			//���������� ������
	private float  g_8;			//�⺻�ı⺻��������
	private float  g_9_1;		//�⺻�� ��ǥ����-12����
	private float  g_9_2;		//�⺻�� ��ǥ����-18����
	private float  g_9_3;		//�⺻�� ��ǥ����-24����
	private float  g_9_4;		//�⺻�� ��ǥ����-30����
	private float  g_9_5;		//�⺻�� ��ǥ����-36����
	private float  g_9_6;		//�⺻�� ��ǥ����-42����
	private float  g_9_7;		//�⺻�� ��ǥ����-48����	-2005.3.23. ����������
	private int    g_10;		//�Ϲݽ� ���ô뿩�� �⺻���� ������
	private float  g_11_1;		//�Ϲݽ� ��ǥ����-12����
    private float  g_11_2;		//�Ϲݽ� ��ǥ����-18����
    private float  g_11_3;		//�Ϲݽ� ��ǥ����-24����
    private float  g_11_4;		//�Ϲݽ� ��ǥ����-30����
	private float  g_11_5;		//�Ϲݽ� ��ǥ����-36����
	private float  g_11_6;		//�Ϲݽ� ��ǥ����-42����
	private float  g_11_7;		//�Ϲݽ� ��ǥ����-48����	-2005.3.23. ������ ����
	private String companys;	//�̿��ֿ����
	private String quiry_nm;	//�̿빮�� �����
	private String quiry_tel;	//�̿빮�� ����ó
    private float  oa_f;		//�������谡����(�������ܴ��)-�Ϲݽ�
    private float  oa_g;		//�����������(���Աݾ״��)
    private float  oa_h;		//�������谡����(�������ܴ��)-�⺻��
	private float  a_f_w;		//�췮��� ����������	-2005.3.25. �߰�.
    private int	   a_g_1_w;		//�췮��� 10��������Һα�-12����
    private int	   a_g_2_w;		//�췮��� 10��������Һα�-18����
    private int	   a_g_3_w;		//�췮��� 10��������Һα�-24����
    private int	   a_g_4_w;		//�췮��� 10��������Һα�-30����
    private int	   a_g_5_w;		//�췮��� 10��������Һα�-36����
	private int	   a_g_6_w;		//�췮��� 10��������Һα�-42����
	private int	   a_g_7_w;		//�췮��� 10��������Һα�-48����
	private float  g_9_11_w;	//�췮��� ��ǥ���� �⺻��,�Ϲݽ� ������ ������� ����. 20050325. �⺻��,�Ϲݽ� �и�20050823
	private float  g_11_w;		//�췮��� �Ϲݽ� ��ǥ���� 
	//20050511 �ʿ췮��� �߰�
	private float  a_f_uw;		//����������
    private int	   a_g_1_uw;	//10��������Һα�-12����
    private int	   a_g_2_uw;	//10��������Һα�-18����
    private int	   a_g_3_uw;	//10��������Һα�-24����
    private int	   a_g_4_uw;	//10��������Һα�-30����
    private int	   a_g_5_uw;	//10��������Һα�-36����
	private int	   a_g_6_uw;	//10��������Һα�-42����
	private int	   a_g_7_uw;	//10��������Һα�-48����
	private float  g_9_11_uw;	//���븶��(20050823 �⺻��)
	private float  g_11_uw;		//���븶��(20050823 �Ϲݽ� �и�)
	//20070323 �ܰ����뺯��
	private float  jg_c_1;		//0���������ܰ�
	private float  jg_c_2;		//����24���� �ܰ��� 2�Ⱓ ������
	private float  jg_c_3;		//������Ͽ��� ���� 12������ �ܰ��� ������
	private float  jg_c_4;		//LPG����� �ܰ��� ���� ������
	private float  jg_c_5;		//LPG����� �ܰ��� 1�⵿ ������
	private float  jg_c_6;		//3�� �ʰ������� �ܰ��� 1�⵿ ������
	private int	   jg_c_a;		//�����л�LPGŰƮ����/Ż�����(���ް�)
	private int	   jg_c_b;		//�����л�LPGŰƮ����/Ż�����(���ް�)
	private float  jg_c_c;		//�ִ��ܰ���� �����ܰ��� 1% ���̴� D/C��
	private float  jg_c_d;		//�����ܰ��� ������ ���� �ִ� D/C��
	//20080108 �߰� //20120203 �����߰�
    private int    o_9_3;		//��Ϻδ���-�λ�
    private int    o_9_4;		//��Ϻδ���-�泲
    private int    o_9_5;		//��Ϻδ���-����
    private int    o_9_7;		//��Ϻδ���-��õ
	private int    o_9_8;		//��Ϻδ���-����
    private float  o_8_3;		//ä��������-�λ�
    private float  o_8_4;		//ä��������-�泲
    private float  o_8_5;		//ä��������-����
    private float  o_8_7;		//ä��������-��õ
	private float  o_8_8;		//ä��������-����
	//20080715 �ܰ����뺯�� �߰�(�縮������)
    private int	   jg_c_71;		//3��ǥ������Ÿ�-���ָ�
    private int	   jg_c_72;		//3��ǥ������Ÿ�-����
    private int	   jg_c_73;		//3��ǥ������Ÿ�-LPG
	private float  jg_c_81;		//ǥ������Ÿ��ʰ� ������-���ָ�LPG
	private float  jg_c_82;		//ǥ������Ÿ��ʰ� ������-����
	private float  jg_c_9;		//24�����ð������ ���� �߰����� �϶���
	private float  jg_c_10;		//LPG�������� 24�����ð������ ���� �߰����� �϶���
	private float  jg_c_11;		//24�����ð������ ���� �߰��� ���� ����Ʈ ������
	//20080716 �縮�����뺯��
	private float  sh_c_a;	
	private float  sh_c_b1;	
	private float  sh_c_b2;	
	private float  sh_c_d1;	
	private float  sh_c_d2;	
	private float  a_m_1;	
	private float  a_m_2;	
	//20081017 �߰����������뺯��
    private int	   sh_p_1;		//�߰������� ��������-���׺���
	private float  sh_p_2;		//�߰������� ��������-��������
	//20081030 ����ȿ������
	private float  bc_s_i;		//CASH BACK��
	//20090810 ����ݻ���
	private float  ax_n;		//ī�����������Ʈ��
	private float  ax_n_c;		//ī�������
	private int	   ax_p;		//����ݻ������ �̿�Ⱓ
	private float  ax_q;		//��������ѱݾ�
	private float  ax_r_1;		//��������ѱݾ�
	private float  ax_r_2;		//��������ѱݾ�
	private float  jg_c_32;		//�縮����Ͽ��� ���� 12������ �ܰ��� ������
	//20130501 ������
	private float  k_su_1;		//������ ���Ҽ��������� ������ ��������ġ
	private float  k_su_2;		//������ ����鼼�� ����¼�
	private float  a_cb_1;		//������ ī����� cash back �ݿ�����
	//20150508 �������� ���� 
	private float  accid_a;		//���� �ڽ¼�
	private float  accid_b;		//���ı��� ������ ����
	private float  accid_c;		//������ �¼�
	private float  accid_d;		//2�� �������� �ݿ���
	private float  accid_e;		//���ؼ����� �̸� �ڽ¼�
	private float  accid_f;		//���ؼ����� �̻� �ڽ¼�
	private float  accid_g;		//���� ������
	private float  accid_h;		//��������¼�
	private float  accid_j;		//���ɹݿ�����
	private float  accid_k;		//����Ÿ�����¼�
	private float  accid_m;		//����Ÿ��ݿ�����
	private float  accid_n;		//���� ����Ÿ��ݿ� �����¼�
	private float  sh_c_k;		//�Ϲݽ¿�LPG �縮�� ���۽��� ����60���� �̻��� ��� �ܰ�������
	private float  sh_c_m;		//�Ϲݽ¿�LPG �縮�� ������� ����60���� �̻��� ��� �ܰ�������
	//20160531 �ܰ����뺯��
	private float  jg_c_12;		//������DC�� �ܰ����� ȿ��
	//20160808 ������/������
    private int    ecar_tax;	//������/������ �ڵ����� (�Ⱓ)
    private String ecar_0_yn;	//������ ����ü������ ���޿��� ����
	private String ecar_1_yn;	//������ ����ü������ ���޿��� ���
	private String ecar_2_yn;	//������ ����ü������ ���޿��� �λ�
	private String ecar_3_yn;	//������ ����ü������ ���޿��� �泲
	private String ecar_4_yn;	//������ ����ü������ ���޿��� ����
	private String ecar_5_yn;	//������ ����ü������ ���޿��� ��õ
	private String ecar_6_yn;	//������ ����ü������ ���޿��� �뱸
	private String ecar_7_yn;	//������ ����ü������ ���޿��� ����
	private String ecar_8_yn;	//������ ����ü������ ���޿��� ��Ÿ
	private String ecar_9_yn;	//������ ����ü������ ���޿��� ��Ÿ
	private String ecar_10_yn;	//������ ����ü������ ���޿��� ��Ÿ
	private int    ecar_0_amt;	//������ ����ü������ ���ޱݾ� ����
	private int    ecar_1_amt;	//������ ����ü������ ���ޱݾ� ���
	private int    ecar_2_amt;	//������ ����ü������ ���ޱݾ� �λ�
	private int    ecar_3_amt;	//������ ����ü������ ���ޱݾ� �泲
	private int    ecar_4_amt;	//������ ����ü������ ���ޱݾ� ����
	private int    ecar_5_amt;	//������ ����ü������ ���ޱݾ� ��õ
	private int    ecar_6_amt;	//������ ����ü������ ���ޱݾ� �뱸
	private int    ecar_7_amt;	//������ ����ü������ ���ޱݾ� ����
	private int    ecar_8_amt;	//������ ����ü������ ���ޱݾ� ��Ÿ
	private int    ecar_9_amt;	//������ ����ü������ ���ޱݾ� ��Ÿ
	private int    ecar_10_amt;	//������ ����ü������ ���ޱݾ� ��Ÿ
	private int    ecar_bat_cost;	//������ �ϼ������� �������
	private float  sh_a_m_1;	
	private float  sh_a_m_2;	
	//20190201 ������
	private int    hcar_0_amt;	//������ ����ü������ ���ޱݾ� ����
	private int    hcar_1_amt;	//������ ����ü������ ���ޱݾ� ���
	private int    hcar_2_amt;	//������ ����ü������ ���ޱݾ� �λ�
	private int    hcar_3_amt;	//������ ����ü������ ���ޱݾ� �泲
	private int    hcar_4_amt;	//������ ����ü������ ���ޱݾ� ����
	private int    hcar_5_amt;	//������ ����ü������ ���ޱݾ� ��õ
	private int    hcar_6_amt;	//������ ����ü������ ���ޱݾ� �뱸
	private int    hcar_7_amt;	//������ ����ü������ ���ޱݾ� ����
	private int    hcar_8_amt;	//������ ����ü������ ���ޱݾ� ��Ÿ
	private int    hcar_9_amt;	//������ ����ü������ ���ޱݾ� ��Ÿ
	private int    hcar_cost;	//������ �ߵ����� ����ũ ������
	//20190621 ��Ÿ���� �߰�
	private float  a_y_1;	//������Ż������
	private float  a_y_2;	//������Ż�����
	private float  a_y_3;	//�������������
	private float  a_y_4;	//������������
	private float  a_y_5;	//����������
	private float  a_y_6;	//���ΰ�(Ʈ���Ϸ���)
	//20191113 
	private float  a_f_2;			//�ʱⳳ�Ա� ���� ������
	private float  a_f_3;			//�߰��� ������ġ ȯ�� ������ 20220629
	private float  oa_extra;		//���ﺸ������ �Ƹ���ī ����������
	private float  oa_g_1;			//���ﺸ������ �ſ�1��� �������
	private float  oa_g_2;			//���ﺸ������ �ſ�2��� �������
	private float  oa_g_3;			//���ﺸ������ �ſ�3��� �������
	private float  oa_g_4;			//���ﺸ������ �ſ�4��� �������
	private float  oa_g_5;			//���ﺸ������ �ſ�5��� �������
	private float  oa_g_6;			//���ﺸ������ �ſ�6��� �������
	private float  oa_g_7;			//���ﺸ������ �ſ�7��� �������
	//20200623 �縮�������� �̵� Ź�۷�
	private int    br_cons_00;		//����-����
	private int    br_cons_01;		//����-����
	private int    br_cons_02;		//����-�뱸
	private int    br_cons_03;		//����-����
	private int    br_cons_04;		//����-�λ�
	private int    br_cons_10;		//����-����
	private int    br_cons_11;		//����-����
	private int    br_cons_12;		//����-�뱸
	private int    br_cons_13;		//����-����
	private int    br_cons_14;		//����-�λ�
	private int    br_cons_20;		//�뱸-����
	private int    br_cons_21;		//�뱸-����
	private int    br_cons_22;		//�뱸-�뱸
	private int    br_cons_23;		//�뱸-����
	private int    br_cons_24;		//�뱸-�λ�
	private int    br_cons_30;		//����-����
	private int    br_cons_31;		//����-����
	private int    br_cons_32;		//����-�뱸
	private int    br_cons_33;		//����-����
	private int    br_cons_34;		//����-�λ�	
	private int    br_cons_40;		//�λ�-����
	private int    br_cons_41;		//�λ�-����
	private int    br_cons_42;		//�λ�-�뱸
	private int    br_cons_43;		//�λ�-����
	private int    br_cons_44;		//�λ�-�λ�	
	//20200914
	private int    car_maint_amt1;	//�ڵ�������˻������
	private int    car_maint_amt2;	//�ڵ������հ˻������
	private int    car_maint_amt3;	//�ڵ������հ˻������-����/������
	private int    tint_b_amt;		//��ǰ��-���ڽ�
	private int    tint_s_amt;		//��ǰ��-�������
	private int    tint_n_amt;		//��ǰ��-������̼�
	private int    tint_eb_amt;		//��ǰ��-�̵���������
	private int    tint_bn_amt;		//��ǰ��-���ڽ�������
	private int    legal_amt;		//��ǰ��-�������������
	private int    car_maint_amt4;	//�ڵ������հ˻������-���������п��˻���
	
	
	// CONSTRCTOR            
    public EstiCommVarBean() {  

    	this.a_a		= "";
    	this.seq		= "";
    	this.a_f		= 0;
    	this.a_g_1		= 0;
    	this.a_g_2		= 0;
    	this.a_g_3		= 0;
    	this.a_g_4		= 0;
    	this.a_g_5		= 0;
		this.a_g_6		= 0;
		this.a_g_7		= 0;
    	this.a_j		= "";
    	this.o_8_1		= 0;
    	this.o_8_2		= 0;
    	this.o_9_1		= 0;
    	this.o_9_2		= 0;
    	this.o_10		= 0;
    	this.o_12		= 0;
		this.o_e		= "";
		this.oa_b		= 0;
		this.oa_c		= 0;
    	this.g_1		= 0;
    	this.g_3		= 0;
    	this.g_5		= 0;
    	this.g_8		= 0;
    	this.g_9_1		= 0;
    	this.g_9_2		= 0;
    	this.g_9_3		= 0;
    	this.g_9_4		= 0;
		this.g_9_5		= 0;
		this.g_9_6		= 0;
		this.g_9_7		= 0;
    	this.g_10		= 0;
    	this.g_11_1		= 0;
    	this.g_11_2		= 0;
    	this.g_11_3		= 0;
    	this.g_11_4		= 0;
		this.g_11_5		= 0;
		this.g_11_6		= 0;
		this.g_11_7		= 0;
		this.companys	= "";
		this.quiry_nm	= "";
		this.quiry_tel	= "";
		this.oa_f		= 0;
		this.oa_g		= 0;
		this.oa_h		= 0;
		this.a_f_w		= 0;
		this.a_g_1_w	= 0;
		this.a_g_2_w	= 0;
		this.a_g_3_w	= 0;
		this.a_g_4_w	= 0;
		this.a_g_5_w	= 0;
		this.a_g_6_w	= 0;
		this.a_g_7_w	= 0;
		this.g_9_11_w	= 0;
		this.g_11_w		= 0;
		this.a_f_uw		= 0;
		this.a_g_1_uw	= 0;
		this.a_g_2_uw	= 0;
		this.a_g_3_uw	= 0;
		this.a_g_4_uw	= 0;
		this.a_g_5_uw	= 0;
		this.a_g_6_uw	= 0;
		this.a_g_7_uw	= 0;
		this.g_9_11_uw	= 0;
		this.g_11_uw	= 0;
		this.jg_c_1		= 0;
		this.jg_c_2		= 0;
		this.jg_c_3		= 0;
		this.jg_c_4		= 0;
		this.jg_c_5		= 0;
		this.jg_c_6		= 0;
		this.jg_c_a		= 0;
		this.jg_c_b		= 0;
		this.jg_c_c		= 0;
		this.jg_c_d		= 0;
    	this.o_9_3		= 0;
    	this.o_9_4		= 0;
    	this.o_9_5		= 0;
    	this.o_9_7		= 0;
		this.o_9_8		= 0;
    	this.o_8_3		= 0;
    	this.o_8_4		= 0;
    	this.o_8_5		= 0;
    	this.o_8_7		= 0;
    	this.o_8_8		= 0;
    	this.jg_c_71	= 0;
    	this.jg_c_72	= 0;
    	this.jg_c_73	= 0;
    	this.jg_c_81	= 0;
    	this.jg_c_82	= 0;
    	this.jg_c_9		= 0;
    	this.jg_c_10	= 0;
    	this.jg_c_11	= 0;
    	this.sh_c_a		= 0;
    	this.sh_c_b1	= 0;
    	this.sh_c_b2	= 0;
    	this.sh_c_d1	= 0;
    	this.sh_c_d2	= 0;
		this.a_m_1		= 0;
		this.a_m_2		= 0;
    	this.sh_p_1		= 0;
    	this.sh_p_2		= 0;
		this.bc_s_i		= 0;
		this.ax_n		= 0;
		this.ax_n_c		= 0;
		this.ax_p		= 0;
		this.ax_q		= 0;
		this.ax_r_1		= 0;
		this.ax_r_2		= 0;
		this.jg_c_32	= 0;
    	this.k_su_1		= 0;
    	this.k_su_2		= 0;
		this.a_cb_1		= 0;
		this.accid_a	= 0;
		this.accid_b	= 0;
		this.accid_c	= 0;
		this.accid_d	= 0;
		this.accid_e	= 0;
		this.accid_f	= 0;
		this.accid_g	= 0;
		this.accid_h	= 0;
		this.accid_j	= 0;
		this.accid_k	= 0;
		this.accid_m	= 0;
		this.accid_n	= 0;
		this.sh_c_k		= 0;
		this.sh_c_m		= 0;
		this.jg_c_12	= 0;
		this.ecar_tax	= 0;
		this.ecar_0_yn	= "";
		this.ecar_1_yn	= "";
		this.ecar_2_yn	= "";
		this.ecar_3_yn	= "";
		this.ecar_4_yn	= "";
		this.ecar_5_yn	= "";
		this.ecar_6_yn	= "";
		this.ecar_7_yn	= "";
		this.ecar_8_yn	= "";
		this.ecar_9_yn	= "";
		this.ecar_10_yn	= "";
		this.ecar_0_amt	= 0;
		this.ecar_1_amt	= 0;
		this.ecar_2_amt	= 0;
		this.ecar_3_amt	= 0;
		this.ecar_4_amt	= 0;
		this.ecar_5_amt	= 0;
		this.ecar_6_amt	= 0;
		this.ecar_7_amt	= 0;
		this.ecar_8_amt	= 0;
		this.ecar_9_amt	= 0;
		this.ecar_10_amt= 0;
		this.ecar_bat_cost = 0;
		this.sh_a_m_1	= 0;
		this.sh_a_m_2	= 0;
		this.hcar_0_amt	= 0;
		this.hcar_1_amt	= 0;
		this.hcar_2_amt	= 0;
		this.hcar_3_amt	= 0;
		this.hcar_4_amt	= 0;
		this.hcar_5_amt	= 0;
		this.hcar_6_amt	= 0;
		this.hcar_7_amt	= 0;
		this.hcar_8_amt	= 0;
		this.hcar_9_amt	= 0;
		this.hcar_cost = 0;
		this.a_y_1 = 0;
		this.a_y_2 = 0;
		this.a_y_3 = 0;
		this.a_y_4 = 0;
		this.a_y_5 = 0;
		this.a_y_6 = 0;
		this.a_f_2		= 0;
		this.a_f_3		= 0;
    	this.oa_extra	= 0;
    	this.oa_g_1		= 0;
    	this.oa_g_2		= 0;
    	this.oa_g_3		= 0;
    	this.oa_g_4		= 0;
    	this.oa_g_5		= 0;
		this.oa_g_6		= 0;
		this.oa_g_7		= 0;		
		this.br_cons_00	= 0;
		this.br_cons_01	= 0;
		this.br_cons_02	= 0;
		this.br_cons_03	= 0;
		this.br_cons_04	= 0;
		this.br_cons_10	= 0;
		this.br_cons_11	= 0;
		this.br_cons_12	= 0;
		this.br_cons_13	= 0;
		this.br_cons_14	= 0;
		this.br_cons_20	= 0;
		this.br_cons_21	= 0;
		this.br_cons_22	= 0;
		this.br_cons_23	= 0;
		this.br_cons_24	= 0;
		this.br_cons_30	= 0;
		this.br_cons_31	= 0;
		this.br_cons_32	= 0;
		this.br_cons_33	= 0;
		this.br_cons_34	= 0;		
		this.br_cons_40	= 0;
		this.br_cons_41	= 0;
		this.br_cons_42	= 0;
		this.br_cons_43	= 0;
		this.br_cons_44	= 0;	
    	this.car_maint_amt1	= 0;
    	this.car_maint_amt2	= 0;
    	this.car_maint_amt3	= 0;
    	this.tint_b_amt		= 0;
    	this.tint_s_amt		= 0;
    	this.tint_n_amt		= 0;
    	this.tint_eb_amt	= 0;
		this.tint_bn_amt	= 0;
		this.legal_amt		= 0;
		this.car_maint_amt4	= 0;
		

	}

	// get Method
    public void setA_a		(String val){		if(val==null) val="";	this.a_a		= val;	}
    public void setSeq		(String val){		if(val==null) val="";	this.seq		= val;	}
	public void setA_f		(float i){									this.a_f		= i;	}
	public void setA_g_1	(int i){									this.a_g_1		= i;	}
	public void setA_g_2	(int i){									this.a_g_2		= i;	}
	public void setA_g_3	(int i){									this.a_g_3		= i;	}
	public void setA_g_4	(int i){									this.a_g_4		= i;	}		
	public void setA_g_5	(int i){									this.a_g_5		= i;	}		
	public void setA_g_6	(int i){									this.a_g_6		= i;	}
	public void setA_g_7	(int i){									this.a_g_7		= i;	}
	public void setA_j		(String val){		if(val==null) val="";	this.a_j		= val;	}
	public void setO_8_1	(float i){									this.o_8_1		= i;	}
	public void setO_8_2	(float i){									this.o_8_2		= i;	}
	public void setO_9_1	(int i){									this.o_9_1		= i;	}
	public void setO_9_2	(int i){									this.o_9_2		= i;	}
	public void setO_10		(float i){									this.o_10		= i;	}
	public void setO_12		(float i){									this.o_12		= i;	}
	public void setO_e		(String val){		if(val==null) val="";	this.o_e		= val;	}
	public void setOa_b		(int i){									this.oa_b		= i;	}
	public void setOa_c		(float i){									this.oa_c		= i;	}
	public void setG_1		(int i){									this.g_1		= i;	}
	public void setG_3		(float i){									this.g_3		= i;	}
	public void setG_5		(float i){									this.g_5		= i;	}
	public void setG_8		(float i){									this.g_8		= i;	}
	public void setG_9_1	(float i){									this.g_9_1		= i;	}
	public void setG_9_2	(float i){									this.g_9_2		= i;	}
	public void setG_9_3	(float i){									this.g_9_3		= i;	}
	public void setG_9_4	(float i){									this.g_9_4		= i;	}
	public void setG_9_5	(float i){									this.g_9_5		= i;	}
	public void setG_9_6	(float i){									this.g_9_6		= i;	}
	public void setG_9_7	(float i){									this.g_9_7		= i;	}
	public void setG_10		(int i){									this.g_10		= i;	}
	public void setG_11_1	(float i){									this.g_11_1		= i;	}
	public void setG_11_2	(float i){									this.g_11_2		= i;	}
	public void setG_11_3	(float i){									this.g_11_3		= i;	}
	public void setG_11_4	(float i){									this.g_11_4		= i;	}
	public void setG_11_5	(float i){									this.g_11_5		= i;	}
	public void setG_11_6	(float i){									this.g_11_6		= i;	}
	public void setG_11_7	(float i){									this.g_11_7		= i;	}
	public void setCompanys	(String val){		if(val==null) val="";	this.companys	= val;	}		
	public void setQuiry_nm	(String val){		if(val==null) val="";	this.quiry_nm	= val;	}
	public void setQuiry_tel(String val){		if(val==null) val="";	this.quiry_tel	= val;	}
	public void setOa_f		(float i){									this.oa_f		= i;	}
	public void setOa_g		(float i){									this.oa_g		= i;	}
	public void setOa_h		(float i){									this.oa_h		= i;	}
	public void setA_f_w	(float i){									this.a_f_w		= i;	}
	public void setA_g_1_w	(int i){									this.a_g_1_w	= i;	}
	public void setA_g_2_w	(int i){									this.a_g_2_w	= i;	}
	public void setA_g_3_w	(int i){									this.a_g_3_w	= i;	}
	public void setA_g_4_w	(int i){									this.a_g_4_w	= i;	}		
	public void setA_g_5_w	(int i){									this.a_g_5_w	= i;	}		
	public void setA_g_6_w	(int i){									this.a_g_6_w	= i;	}
	public void setA_g_7_w	(int i){									this.a_g_7_w	= i;	}
	public void setG_9_11_w	(float i){									this.g_9_11_w	= i;	}
	public void setG_11_w	(float i){									this.g_11_w		= i;	}
	public void setA_f_uw	(float i){									this.a_f_uw		= i;	}
	public void setA_g_1_uw	(int i){									this.a_g_1_uw	= i;	}
	public void setA_g_2_uw	(int i){									this.a_g_2_uw	= i;	}
	public void setA_g_3_uw	(int i){									this.a_g_3_uw	= i;	}
	public void setA_g_4_uw	(int i){									this.a_g_4_uw	= i;	}		
	public void setA_g_5_uw	(int i){									this.a_g_5_uw	= i;	}		
	public void setA_g_6_uw	(int i){									this.a_g_6_uw	= i;	}
	public void setA_g_7_uw	(int i){									this.a_g_7_uw	= i;	}
	public void setG_9_11_uw(float i){									this.g_9_11_uw	= i;	}
	public void setG_11_uw	(float i){									this.g_11_uw	= i;	}
	public void setJg_c_1	(float i){									this.jg_c_1		= i;	}
	public void setJg_c_2	(float i){									this.jg_c_2		= i;	}
	public void setJg_c_3	(float i){									this.jg_c_3		= i;	}
	public void setJg_c_4	(float i){									this.jg_c_4		= i;	}
	public void setJg_c_5	(float i){									this.jg_c_5		= i;	}
	public void setJg_c_6	(float i){									this.jg_c_6		= i;	}
	public void setJg_c_a	(int i){									this.jg_c_a		= i;	}
	public void setJg_c_b	(int i){									this.jg_c_b		= i;	}
	public void setJg_c_c	(float i){									this.jg_c_c		= i;	}
	public void setJg_c_d	(float i){									this.jg_c_d		= i;	}
	public void setO_9_3	(int i){									this.o_9_3		= i;	}
	public void setO_9_4	(int i){									this.o_9_4		= i;	}
	public void setO_9_5	(int i){									this.o_9_5		= i;	}
	public void setO_9_7	(int i){									this.o_9_7		= i;	}
	public void setO_9_8	(int i){									this.o_9_8		= i;	}
	public void setO_8_3	(float i){									this.o_8_3		= i;	}
	public void setO_8_4	(float i){									this.o_8_4		= i;	}
	public void setO_8_5	(float i){									this.o_8_5		= i;	}
	public void setO_8_7	(float i){									this.o_8_7		= i;	}
	public void setO_8_8	(float i){									this.o_8_8		= i;	}
	public void setJg_c_71	(int i){									this.jg_c_71	= i;	}
	public void setJg_c_72	(int i){									this.jg_c_72	= i;	}
	public void setJg_c_73	(int i){									this.jg_c_73	= i;	}
	public void setJg_c_81	(float i){									this.jg_c_81	= i;	}
	public void setJg_c_82	(float i){									this.jg_c_82	= i;	}
	public void setJg_c_9	(float i){									this.jg_c_9		= i;	}
	public void setJg_c_10	(float i){									this.jg_c_10	= i;	}
	public void setJg_c_11	(float i){									this.jg_c_11	= i;	}
	public void setSh_c_a	(float i){									this.sh_c_a		= i;	}
	public void setSh_c_b1	(float i){									this.sh_c_b1	= i;	}
	public void setSh_c_b2	(float i){									this.sh_c_b2	= i;	}
	public void setSh_c_d1	(float i){									this.sh_c_d1	= i;	}
	public void setSh_c_d2	(float i){									this.sh_c_d2	= i;	}
	public void setA_m_1	(float i){									this.a_m_1		= i;	}
	public void setA_m_2	(float i){									this.a_m_2		= i;	}
	public void setSh_p_1	(int i)  {									this.sh_p_1		= i;	}
	public void setSh_p_2	(float i){									this.sh_p_2		= i;	}
	public void setBc_s_i	(float i){									this.bc_s_i		= i;	}
	public void setAx_n		(float i){									this.ax_n		= i;	}
	public void setAx_n_c	(float i){									this.ax_n_c		= i;	}
	public void setAx_p		(int i)  {									this.ax_p		= i;	}
	public void setAx_q		(float i){									this.ax_q		= i;	}
	public void setAx_r_1	(float i){									this.ax_r_1		= i;	}
	public void setAx_r_2	(float i){									this.ax_r_2		= i;	}
	public void setJg_c_32	(float i){									this.jg_c_32	= i;	}
	public void setK_su_1	(float i){									this.k_su_1		= i;	}
	public void setK_su_2	(float i){									this.k_su_2		= i;	}
	public void setA_cb_1	(float i){									this.a_cb_1		= i;	}
	public void setAccid_a	(float i){									this.accid_a	= i;	}
	public void setAccid_b	(float i){									this.accid_b	= i;	}
	public void setAccid_c	(float i){									this.accid_c	= i;	}
	public void setAccid_d	(float i){									this.accid_d	= i;	}
	public void setAccid_e	(float i){									this.accid_e	= i;	}
	public void setAccid_f	(float i){									this.accid_f	= i;	}
	public void setAccid_g	(float i){									this.accid_g	= i;	}
	public void setAccid_h	(float i){									this.accid_h	= i;	}
	public void setAccid_j	(float i){									this.accid_j	= i;	}
	public void setAccid_k	(float i){									this.accid_k	= i;	}
	public void setAccid_m	(float i){									this.accid_m	= i;	}
	public void setAccid_n	(float i){									this.accid_n	= i;	}
	public void setSh_c_k	(float i){									this.sh_c_k		= i;	}
	public void setSh_c_m	(float i){									this.sh_c_m		= i;	}
	public void setJg_c_12	(float i){									this.jg_c_12	= i;	}
	public void setEcar_tax(int i)  {									this.ecar_tax	= i;	}
	public void setEcar_0_yn(String val){		if(val==null) val="";	this.ecar_0_yn	= val;	}
	public void setEcar_1_yn(String val){		if(val==null) val="";	this.ecar_1_yn	= val;	}
	public void setEcar_2_yn(String val){		if(val==null) val="";	this.ecar_2_yn	= val;	}
	public void setEcar_3_yn(String val){		if(val==null) val="";	this.ecar_3_yn	= val;	}
	public void setEcar_4_yn(String val){		if(val==null) val="";	this.ecar_4_yn	= val;	}
	public void setEcar_5_yn(String val){		if(val==null) val="";	this.ecar_5_yn	= val;	}
	public void setEcar_6_yn(String val){		if(val==null) val="";	this.ecar_6_yn	= val;	}
	public void setEcar_7_yn(String val){		if(val==null) val="";	this.ecar_7_yn	= val;	}
	public void setEcar_8_yn(String val){		if(val==null) val="";	this.ecar_8_yn	= val;	}
	public void setEcar_9_yn(String val){		if(val==null) val="";	this.ecar_9_yn	= val;	}
	public void setEcar_10_yn(String val){		if(val==null) val="";	this.ecar_10_yn	= val;	}
	public void setEcar_0_amt(int i)  {									this.ecar_0_amt	= i;	}
	public void setEcar_1_amt(int i)  {									this.ecar_1_amt	= i;	}
	public void setEcar_2_amt(int i)  {									this.ecar_2_amt	= i;	}
	public void setEcar_3_amt(int i)  {									this.ecar_3_amt	= i;	}
	public void setEcar_4_amt(int i)  {									this.ecar_4_amt	= i;	}
	public void setEcar_5_amt(int i)  {									this.ecar_5_amt	= i;	}
	public void setEcar_6_amt(int i)  {									this.ecar_6_amt	= i;	}
	public void setEcar_7_amt(int i)  {									this.ecar_7_amt	= i;	}
	public void setEcar_8_amt(int i)  {									this.ecar_8_amt	= i;	}
	public void setEcar_9_amt(int i)  {									this.ecar_9_amt	= i;	}
	public void setEcar_10_amt(int i)  {								this.ecar_10_amt= i;	}
	public void setEcar_bat_cost(int i)  {								this.ecar_bat_cost = i;	}
	public void setSh_a_m_1	(float i){									this.sh_a_m_1	= i;	}
	public void setSh_a_m_2	(float i){									this.sh_a_m_2	= i;	}
	public void setHcar_0_amt(int i)  {									this.hcar_0_amt	= i;	}
	public void setHcar_1_amt(int i)  {									this.hcar_1_amt	= i;	}
	public void setHcar_2_amt(int i)  {									this.hcar_2_amt	= i;	}
	public void setHcar_3_amt(int i)  {									this.hcar_3_amt	= i;	}
	public void setHcar_4_amt(int i)  {									this.hcar_4_amt	= i;	}
	public void setHcar_5_amt(int i)  {									this.hcar_5_amt	= i;	}
	public void setHcar_6_amt(int i)  {									this.hcar_6_amt	= i;	}
	public void setHcar_7_amt(int i)  {									this.hcar_7_amt	= i;	}
	public void setHcar_8_amt(int i)  {									this.hcar_8_amt	= i;	}
	public void setHcar_9_amt(int i)  {									this.hcar_9_amt	= i;	}
	public void setHcar_cost(int i)  {									this.hcar_cost = i;		}	
	public void setA_y_1	(float i){									this.a_y_1		= i;	}
	public void setA_y_2	(float i){									this.a_y_2		= i;	}
	public void setA_y_3	(float i){									this.a_y_3		= i;	}
	public void setA_y_4	(float i){									this.a_y_4		= i;	}
	public void setA_y_5	(float i){									this.a_y_5		= i;	}
	public void setA_y_6	(float i){									this.a_y_6		= i;	}
	public void setA_f_2	(float i){									this.a_f_2		= i;	}
	public void setA_f_3	(float i){									this.a_f_3		= i;	}
	public void setOa_extra	(float i){									this.oa_extra	= i;	}
	public void setOa_g_1	(float i){									this.oa_g_1		= i;	}
	public void setOa_g_2	(float i){									this.oa_g_2		= i;	}
	public void setOa_g_3	(float i){									this.oa_g_3		= i;	}
	public void setOa_g_4	(float i){									this.oa_g_4		= i;	}		
	public void setOa_g_5	(float i){									this.oa_g_5		= i;	}		
	public void setOa_g_6	(float i){									this.oa_g_6		= i;	}
	public void setOa_g_7	(float i){									this.oa_g_7		= i;	}	
	public void setBr_cons_00(int i)  {									this.br_cons_00	= i;	}
	public void setBr_cons_01(int i)  {									this.br_cons_01	= i;	}
	public void setBr_cons_02(int i)  {									this.br_cons_02	= i;	}
	public void setBr_cons_03(int i)  {									this.br_cons_03	= i;	}
	public void setBr_cons_04(int i)  {									this.br_cons_04	= i;	}
	public void setBr_cons_10(int i)  {									this.br_cons_10	= i;	}
	public void setBr_cons_11(int i)  {									this.br_cons_11	= i;	}
	public void setBr_cons_12(int i)  {									this.br_cons_12	= i;	}
	public void setBr_cons_13(int i)  {									this.br_cons_13	= i;	}
	public void setBr_cons_14(int i)  {									this.br_cons_14	= i;	}
	public void setBr_cons_20(int i)  {									this.br_cons_20	= i;	}
	public void setBr_cons_21(int i)  {									this.br_cons_21	= i;	}
	public void setBr_cons_22(int i)  {									this.br_cons_22	= i;	}
	public void setBr_cons_23(int i)  {									this.br_cons_23	= i;	}
	public void setBr_cons_24(int i)  {									this.br_cons_24	= i;	}
	public void setBr_cons_30(int i)  {									this.br_cons_30	= i;	}
	public void setBr_cons_31(int i)  {									this.br_cons_31	= i;	}
	public void setBr_cons_32(int i)  {									this.br_cons_32	= i;	}
	public void setBr_cons_33(int i)  {									this.br_cons_33	= i;	}
	public void setBr_cons_34(int i)  {									this.br_cons_34	= i;	}
	public void setBr_cons_40(int i)  {									this.br_cons_40	= i;	}
	public void setBr_cons_41(int i)  {									this.br_cons_41	= i;	}
	public void setBr_cons_42(int i)  {									this.br_cons_42	= i;	}
	public void setBr_cons_43(int i)  {									this.br_cons_43	= i;	}
	public void setBr_cons_44(int i)  {									this.br_cons_44	= i;	}	
	public void setCar_maint_amt1	(int i){							this.car_maint_amt1	= i;	}
	public void setCar_maint_amt2	(int i){							this.car_maint_amt2	= i;	}
	public void setCar_maint_amt3	(int i){							this.car_maint_amt3	= i;	}
	public void setTint_b_amt		(int i){							this.tint_b_amt		= i;	}
	public void setTint_s_amt		(int i){							this.tint_s_amt		= i;	}		
	public void setTint_n_amt		(int i){							this.tint_n_amt		= i;	}		
	public void setTint_eb_amt		(int i){							this.tint_eb_amt	= i;	}
	public void setTint_bn_amt		(int i){							this.tint_bn_amt	= i;	}
	public void setLegal_amt		(int i){							this.legal_amt		= i;	}
	public void setCar_maint_amt4	(int i){							this.car_maint_amt4	= i;	}


	//Get Method
	public String getA_a	    (){		return a_a;		}
	public String getSeq	    (){		return seq;		}
	public float  getA_f		(){		return a_f;		}
	public int    getA_g_1		(){		return a_g_1;	}
	public int    getA_g_2		(){		return a_g_2;	}
	public int    getA_g_3		(){		return a_g_3;	}
	public int    getA_g_4		(){		return a_g_4;	}		
	public int    getA_g_5		(){		return a_g_5;	}		
	public int    getA_g_6		(){		return a_g_6;	}
	public int    getA_g_7		(){		return a_g_7;	}
	public String getA_j		(){		return a_j;		}
	public float  getO_8_1		(){		return o_8_1;	}
	public float  getO_8_2		(){		return o_8_2;	}
	public int    getO_9_1		(){		return o_9_1;	}
	public int    getO_9_2		(){		return o_9_2;	}
	public float  getO_10		(){		return o_10;	}
	public float  getO_12		(){		return o_12;	}
	public String getO_e		(){		return o_e;		}
	public int    getOa_b		(){		return oa_b;	}
	public float  getOa_c		(){		return oa_c;	}
	public int    getG_1		(){		return g_1;		}
	public float  getG_3		(){		return g_3;		}
	public float  getG_5		(){		return g_5;		}
	public float  getG_8		(){		return g_8;		}
	public float  getG_9_1		(){		return g_9_1;	}
	public float  getG_9_2		(){		return g_9_2;	}
	public float  getG_9_3		(){		return g_9_3;	}
	public float  getG_9_4		(){		return g_9_4;	}
	public float  getG_9_5		(){		return g_9_5;	}
	public float  getG_9_6		(){		return g_9_6;	}
	public float  getG_9_7		(){		return g_9_7;	}
	public int    getG_10		(){		return g_10;	}
	public float  getG_11_1		(){		return g_11_1;	}
	public float  getG_11_2		(){		return g_11_2;	}
	public float  getG_11_3		(){		return g_11_3;	}
	public float  getG_11_4		(){		return g_11_4;	}
	public float  getG_11_5		(){		return g_11_5;	}
	public float  getG_11_6		(){		return g_11_6;	}
	public float  getG_11_7		(){		return g_11_7;	}
	public String getCompanys	(){		return companys;}
	public String getQuiry_nm	(){		return quiry_nm;}
	public String getQuiry_tel	(){		return quiry_tel;}
	public float  getOa_f		(){		return oa_f;	}
	public float  getOa_g		(){		return oa_g;	}
	public float  getOa_h		(){		return oa_h;	}
	public float  getA_f_w		(){		return a_f_w;	}
	public int    getA_g_1_w	(){		return a_g_1_w;	}
	public int    getA_g_2_w	(){		return a_g_2_w;	}
	public int    getA_g_3_w	(){		return a_g_3_w;	}
	public int    getA_g_4_w	(){		return a_g_4_w;	}		
	public int    getA_g_5_w	(){		return a_g_5_w;	}		
	public int    getA_g_6_w	(){		return a_g_6_w;	}
	public int    getA_g_7_w	(){		return a_g_7_w;	}
	public float  getG_9_11_w	(){		return g_9_11_w;}
	public float  getG_11_w		(){		return g_11_w;	}
	public float  getA_f_uw		(){		return a_f_uw;	}
	public int    getA_g_1_uw	(){		return a_g_1_uw;}
	public int    getA_g_2_uw	(){		return a_g_2_uw;}
	public int    getA_g_3_uw	(){		return a_g_3_uw;}
	public int    getA_g_4_uw	(){		return a_g_4_uw;}		
	public int    getA_g_5_uw	(){		return a_g_5_uw;}		
	public int    getA_g_6_uw	(){		return a_g_6_uw;}
	public int    getA_g_7_uw	(){		return a_g_7_uw;}
	public float  getG_9_11_uw	(){		return g_9_11_uw;}
	public float  getG_11_uw	(){		return g_11_uw;	}
	public float  getJg_c_1		(){		return jg_c_1;	}
	public float  getJg_c_2		(){		return jg_c_2;	}
	public float  getJg_c_3		(){		return jg_c_3;	}
	public float  getJg_c_4		(){		return jg_c_4;	}
	public float  getJg_c_5		(){		return jg_c_5;	}
	public float  getJg_c_6		(){		return jg_c_6;	}
	public int    getJg_c_a		(){		return jg_c_a;	}
	public int    getJg_c_b		(){		return jg_c_b;	}
	public float  getJg_c_c		(){		return jg_c_c;	}
	public float  getJg_c_d		(){		return jg_c_d;	}
	public int    getO_9_3		(){		return o_9_3;	}
	public int    getO_9_4		(){		return o_9_4;	}
	public int    getO_9_5		(){		return o_9_5;	}
	public int    getO_9_7		(){		return o_9_7;	}
	public int    getO_9_8		(){		return o_9_8;	}
	public float  getO_8_3		(){		return o_8_3;	}
	public float  getO_8_4		(){		return o_8_4;	}
	public float  getO_8_5		(){		return o_8_5;	}
	public float  getO_8_7		(){		return o_8_7;	}
	public float  getO_8_8		(){		return o_8_8;	}
	public int    getJg_c_71	(){		return jg_c_71;	}
	public int    getJg_c_72	(){		return jg_c_72;	}
	public int    getJg_c_73	(){		return jg_c_73;	}
	public float  getJg_c_81	(){		return jg_c_81;	}
	public float  getJg_c_82	(){		return jg_c_82;	}
	public float  getJg_c_9		(){		return jg_c_9;	}
	public float  getJg_c_10	(){		return jg_c_10;	}
	public float  getJg_c_11	(){		return jg_c_11;	}
	public float  getSh_c_a		(){		return sh_c_a;	}
	public float  getSh_c_b1	(){		return sh_c_b1;	}
	public float  getSh_c_b2	(){		return sh_c_b2;	}
	public float  getSh_c_d1	(){		return sh_c_d1;	}
	public float  getSh_c_d2	(){		return sh_c_d2;	}
	public float  getA_m_1		(){		return a_m_1;	}
	public float  getA_m_2		(){		return a_m_2;	}
	public int    getSh_p_1		(){		return sh_p_1;	}
	public float  getSh_p_2		(){		return sh_p_2;	}
	public float  getBc_s_i		(){		return bc_s_i;	}
	public float  getAx_n		(){		return ax_n;	}
	public float  getAx_n_c		(){		return ax_n_c;	}
	public int    getAx_p		(){		return ax_p;	}
	public float  getAx_q		(){		return ax_q;	}
	public float  getAx_r_1		(){		return ax_r_1;	}
	public float  getAx_r_2		(){		return ax_r_2;	}
	public float  getJg_c_32	(){		return jg_c_32;	}
	public float  getK_su_1		(){		return k_su_1;	}
	public float  getK_su_2		(){		return k_su_2;	}
	public float  getA_cb_1		(){		return a_cb_1;	}
	public float  getAccid_a	(){		return accid_a;	}
	public float  getAccid_b	(){		return accid_b;	}
	public float  getAccid_c	(){		return accid_c;	}
	public float  getAccid_d	(){		return accid_d;	}
	public float  getAccid_e	(){		return accid_e;	}
	public float  getAccid_f	(){		return accid_f;	}
	public float  getAccid_g	(){		return accid_g;	}
	public float  getAccid_h	(){		return accid_h;	}
	public float  getAccid_j	(){		return accid_j;	}
	public float  getAccid_k	(){		return accid_k;	}
	public float  getAccid_m	(){		return accid_m;	}
	public float  getAccid_n	(){		return accid_n;	}
	public float  getSh_c_k		(){		return sh_c_k;	}
	public float  getSh_c_m		(){		return sh_c_m;	}
	public float  getJg_c_12	(){		return jg_c_12;	}
	public int    getEcar_tax	(){		return ecar_tax;	}
	public String getEcar_0_yn	(){		return ecar_0_yn;	}
	public String getEcar_1_yn	(){		return ecar_1_yn;	}
	public String getEcar_2_yn	(){		return ecar_2_yn;	}
	public String getEcar_3_yn	(){		return ecar_3_yn;	}
	public String getEcar_4_yn	(){		return ecar_4_yn;	}
	public String getEcar_5_yn	(){		return ecar_5_yn;	}
	public String getEcar_6_yn	(){		return ecar_6_yn;	}
	public String getEcar_7_yn	(){		return ecar_7_yn;	}
	public String getEcar_8_yn	(){		return ecar_8_yn;	}
	public String getEcar_9_yn	(){		return ecar_9_yn;	}
	public String getEcar_10_yn	(){		return ecar_10_yn;	}
	public int    getEcar_0_amt	(){		return ecar_0_amt;	}
	public int    getEcar_1_amt	(){		return ecar_1_amt;	}
	public int    getEcar_2_amt	(){		return ecar_2_amt;	}
	public int    getEcar_3_amt	(){		return ecar_3_amt;	}
	public int    getEcar_4_amt	(){		return ecar_4_amt;	}
	public int    getEcar_5_amt	(){		return ecar_5_amt;	}
	public int    getEcar_6_amt	(){		return ecar_6_amt;	}
	public int    getEcar_7_amt	(){		return ecar_7_amt;	}
	public int    getEcar_8_amt	(){		return ecar_8_amt;	}
	public int    getEcar_9_amt	(){		return ecar_9_amt;	}
	public int    getEcar_10_amt(){		return ecar_10_amt;	}
	public int    getEcar_bat_cost(){	return ecar_bat_cost;}
	public float  getSh_a_m_1	(){		return sh_a_m_1;	}
	public float  getSh_a_m_2	(){		return sh_a_m_2;	}
	public int    getHcar_0_amt	(){		return hcar_0_amt;	}
	public int    getHcar_1_amt	(){		return hcar_1_amt;	}
	public int    getHcar_2_amt	(){		return hcar_2_amt;	}
	public int    getHcar_3_amt	(){		return hcar_3_amt;	}
	public int    getHcar_4_amt	(){		return hcar_4_amt;	}
	public int    getHcar_5_amt	(){		return hcar_5_amt;	}
	public int    getHcar_6_amt	(){		return hcar_6_amt;	}
	public int    getHcar_7_amt	(){		return hcar_7_amt;	}
	public int    getHcar_8_amt	(){		return hcar_8_amt;	}
	public int    getHcar_9_amt	(){		return hcar_9_amt;	}
	public int    getHcar_cost	(){		return hcar_cost;	}
	public float  getA_y_1		(){		return a_y_1;	}
	public float  getA_y_2		(){		return a_y_2;	}
	public float  getA_y_3		(){		return a_y_3;	}
	public float  getA_y_4		(){		return a_y_4;	}
	public float  getA_y_5		(){		return a_y_5;	}	
	public float  getA_y_6		(){		return a_y_6;	}	
	public float  getA_f_2		(){		return a_f_2;	}
	public float  getA_f_3		(){		return a_f_3;	}
	public float  getOa_extra	(){		return oa_extra;}
	public float  getOa_g_1		(){		return oa_g_1;	}
	public float  getOa_g_2		(){		return oa_g_2;	}
	public float  getOa_g_3		(){		return oa_g_3;	}
	public float  getOa_g_4		(){		return oa_g_4;	}		
	public float  getOa_g_5		(){		return oa_g_5;	}		
	public float  getOa_g_6		(){		return oa_g_6;	}
	public float  getOa_g_7		(){		return oa_g_7;	}		
	public int    getBr_cons_00	(){		return br_cons_00;	}
	public int    getBr_cons_01	(){		return br_cons_01;	}
	public int    getBr_cons_02	(){		return br_cons_02;	}
	public int    getBr_cons_03	(){		return br_cons_03;	}
	public int    getBr_cons_04	(){		return br_cons_04;	}
	public int    getBr_cons_10	(){		return br_cons_10;	}
	public int    getBr_cons_11	(){		return br_cons_11;	}
	public int    getBr_cons_12	(){		return br_cons_12;	}
	public int    getBr_cons_13	(){		return br_cons_13;	}
	public int    getBr_cons_14	(){		return br_cons_14;	}
	public int    getBr_cons_20	(){		return br_cons_20;	}
	public int    getBr_cons_21	(){		return br_cons_21;	}
	public int    getBr_cons_22	(){		return br_cons_22;	}
	public int    getBr_cons_23	(){		return br_cons_23;	}
	public int    getBr_cons_24	(){		return br_cons_24;	}
	public int    getBr_cons_30	(){		return br_cons_30;	}
	public int    getBr_cons_31	(){		return br_cons_31;	}
	public int    getBr_cons_32	(){		return br_cons_32;	}
	public int    getBr_cons_33	(){		return br_cons_33;	}
	public int    getBr_cons_34	(){		return br_cons_34;	}
	public int    getBr_cons_40	(){		return br_cons_40;	}
	public int    getBr_cons_41	(){		return br_cons_41;	}
	public int    getBr_cons_42	(){		return br_cons_42;	}
	public int    getBr_cons_43	(){		return br_cons_43;	}
	public int    getBr_cons_44	(){		return br_cons_44;	}	
	public int    getCar_maint_amt1	(){		return car_maint_amt1;	}
	public int    getCar_maint_amt2	(){		return car_maint_amt2;	}
	public int    getCar_maint_amt3	(){		return car_maint_amt3;	}
	public int    getTint_b_amt		(){		return tint_b_amt;		}
	public int    getTint_s_amt		(){		return tint_s_amt;		}		
	public int    getTint_n_amt		(){		return tint_n_amt;		}		
	public int    getTint_eb_amt	(){		return tint_eb_amt;		}
	public int    getTint_bn_amt	(){		return tint_bn_amt;		}
	public int    getLegal_amt		(){		return legal_amt;		}
	public int    getCar_maint_amt4	(){		return car_maint_amt4;	}
	

}